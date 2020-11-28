#include <stdio.h>

void test() {
   // declaring pointer of FILE type
   FILE *fp1, *fp2;
   char c;

   // pointing fp1 to a file geeky.txt to read from it.
   fp1 = fopen("geeky.txt", "r");

   // pointing fp2 to a file outgeeky.txt
   // to write to it.
   fp2 = fopen("outgeeky.txt", "w");

   // reading a character from file.
   fscanf(fp1, "%c", &c);

   // writing a character to file.
   fprintf(fp2, "%c", c);
}
