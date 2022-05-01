#include <iostream>


using namespace std;
#include "../src/symtab.h"

int main(){
    SymTab *symTab = new SymTab("global", "program");
    symTab->add("hello", "var", "int", "global", 2, false);

    Entry *en = symTab->search("hlo");
    if(en != nullptr){
        cout << en->getID();
    }else{
        cout<<"succ";
    }

    return 0;
}
