#ifndef FUNCTAB_H
#define FUNCTAB_H
#include <string>
#include <symtab.h>
#include <vector>
#include <unordered_map>

class FunctionEntry{
private:
    std::string name;
    char retType;
    std::string signature;
    std::vector<SymTab> varTables;
public:
    FunctionEntry(std::string name, char retType, std::string signature);
    void addToVarTab();
};

class FuncTab{
private:
    std::vector<FunctionEntry> funcEntries;

public:
    FuncTab(std::string name, char retType);
    void addSymTable(std::string id, std::string scope);
};

// FuncTab::FuncTab(std::string name, char retType){
//     this->name = name;
//     this->retType = retType;
//     // this->varTables = new std::vector<SymTab>();
// }

// void FuncTab::addSymTable(std::string id, std::string scope){
//     SymTab temp = SymTab(id, scope);
//     varTables.push_back(temp);
// }


#endif