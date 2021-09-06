//codigo del esclavo
//COM 7

#include "BluetoothSerial.h"
#include <SPI.h>      // incluye libreria bus SPI
#include <MFRC522.h>      // incluye libreria especifica para MFRC522

#define RXD2 16
#define TXD2 17
#define RST_PIN  22     // constante para referenciar pin de reset
#define SS_PIN   5      // constante para referenciar pin de slave select

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

MFRC522 mfrc522(SS_PIN, RST_PIN); // crea objeto mfrc522 enviando pines de slave select y reset
BluetoothSerial SerialBT;

byte LecturaUID[4];         // crea array para almacenar el UID leido
byte Usuario1[4]= {0xEA, 0x05, 0x60, 0xD3} ;    // UID de tarjeta leido en programa 1
byte Usuario2[4]= {0x72, 0xB1, 0x0B, 0x24} ;    // UID de llavero leido en programa 1
char dato;
bool enable;
String ID;

void setup() {
  enable = 0;
  Serial.begin(9600);
  SPI.begin();
  SerialBT.begin("ESP32test"); //Bluetooth device name
  mfrc522.PCD_Init();  
  Serial.println("Listo"); 
  Serial.println("The device started, now you can pair it with bluetooth!");
  Serial2.begin(9600,SERIAL_8N1,RXD2,TXD2);  
}

void loop() {
  
  if ( ! mfrc522.PICC_IsNewCardPresent()) // si no hay una tarjeta presente
      return;           // retorna al loop esperando por una tarjeta
      
  if ( ! mfrc522.PICC_ReadCardSerial())     // si no puede obtener datos de la tarjeta
    return;           // retorna al loop esperando por otra tarjeta
    
    Serial.print("UID:");       // muestra texto UID:
    for (byte i = 0; i < mfrc522.uid.size; i++) { // bucle recorre de a un byte por vez el UID
      if (mfrc522.uid.uidByte[i] < 0x10){   // si el byte leido es menor a 0x10
        Serial.print(" 0");       // imprime espacio en blanco y numero cero
      }
      else{           // sino
        Serial.print(" ");        // imprime un espacio en blanco
      }
      Serial.print(mfrc522.uid.uidByte[i], HEX);    // imprime el byte del UID leido en hexadecimal
      LecturaUID[i]=mfrc522.uid.uidByte[i];     // almacena en array el byte del UID leido      
    }
          
    Serial.print("\t");         // imprime un espacio de tabulacion             
                    
    if(comparaUID(LecturaUID, Usuario1)){    // llama a funcion comparaUID con Usuario1
      Serial.println("Bienvenido Usuario 01: Sr. Rodrigo Robles"); // si retorna verdadero muestra texto bienvenida
      enable = 1;
      ID = "01";
    }
    else if(comparaUID(LecturaUID, Usuario2)){ // llama a funcion comparaUID con Usuario2
      Serial.println("Bienvenido Usuario 02: Sr. Samuel Mendez"); // si retorna verdadero muestra texto bienvenida
      enable = 1;
      ID = "02";
    }
    else{           // si retorna falso
      Serial.println("No te conozco");    // muestra texto equivalente a acceso denegado          
      enable = 0;
    }  
    mfrc522.PICC_HaltA();     // detiene comunicacion con tarjeta  

  while(enable){
    if (SerialBT.available()) {
    dato = SerialBT.read();
    if(dato == '|'){
      Serial.println();
      Serial.print("  ");
      Serial.print(dato);
      Serial2.write(dato); 
    }
    
    else if(dato == 'I'){
      Serial.print("  ");
      Serial.print(ID[0]);
      Serial2.write(ID[0]);
    }
    else if(dato == 'D'){
      Serial.print("  ");
      Serial.print(ID[1]);
      Serial2.write(ID[1]);
    }
    else{
      Serial.print("  ");
      Serial.print(dato);
      Serial2.write(dato);  
    }
    delay(1000);
  }
  else{
    Serial.print("  ");
    Serial.write('|');
    Serial2.write('|');
    delay(1000);

    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);

    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);


    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);

    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);

    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);

    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);

    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);

    Serial.print("  ");
    Serial.write('0');
    Serial2.write('0');
    delay(1000);

    Serial.print("  ");
    Serial.write(ID[0]);
    Serial2.write(ID[0]);
    delay(1000);

    Serial.print("  ");
    Serial.write(ID[1]);
    Serial2.write(ID[1]);

    Serial.write('\n');
    delay(1000);
  }
  }
   
}

boolean comparaUID(byte lectura[],byte usuario[]) // funcion comparaUID
{
  for (byte i=0; i < mfrc522.uid.size; i++){    // bucle recorre de a un byte por vez el UID
  if(lectura[i] != usuario[i])        // si byte de UID leido es distinto a usuario
    return(false);          // retorna falso
  }
  return(true);           // si los 4 bytes coinciden retorna verdadero
}
