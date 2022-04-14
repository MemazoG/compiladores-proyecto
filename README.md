# Avance #1 - Léxico y Sintaxis

Fecha: 13 de abril de 2022

Equipo: FML

Integrantes:
- Guillermo Andrés García Vázquez A01283254
- Fernando Martínez Ortiz A01138576

## Descripción del avance
Este avance incluye los analizadores de léxico y de sintaxis, hechos con Flex y Bison, respectivamente.
La parte del analizador léxico se incluye en el archivo de `lexer.h` y el analizador sintáctico en el archivo `parser.y`.
De igual manera, se incluye un archivo llamado `example.txt`, el cual sirve como un ejemplo de un programa escrito en FML.

## Bugs conocidos en esta version
- Al momento de crear un id, si dicho id contiene un substring que sea igual a una palabra reservada, causa un bug en donde detecta dos IDs cuando deberia de detectar uno.
- Detecta la declaracion de la funcion main como declaracion de una funcion normal, esperando un ID en lugar de la palabra reservada "main"
