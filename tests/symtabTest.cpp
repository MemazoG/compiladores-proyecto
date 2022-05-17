#include <iostream>


using namespace std;
#include "../src/symtab.h"
#include "../src/funcTab.h"

int main(){
    
    // FuncTab *funcTab = new FuncTab();
    SymTab *symTab = new SymTab("global", "program");
    symTab->add("hello", "var", "int", "global", 2);

    Entry *en = symTab->search("hlo");
    if(en != nullptr){
        cout << en->getID();
    }else{
        cout<<"succ";
    }

    return 0;
}
