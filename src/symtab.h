#ifndef SYMTAB_H
#define SYMTAB_H

#include <vector>
#include <unordered_map>

class Entry{
private:
    std::string id;
    std::string type;
    std::string dataType;
    std::string scope;
    int lineNum;
    bool hasScope;
public:
    Entry(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, bool hasScope);

    std::string getID(){return this->id;};
};

Entry::Entry(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, bool hasScope){
    this->id = id;
    this->type = type;
    this->dataType = dataType;
    this->scope = scope;
    this->lineNum = lineNum;
    this->hasScope = hasScope;
}

class SymTab{

private:
    std::unordered_map<std::string, Entry*> table;
    std::string scope;
    std::string id;
    std::vector<Entry> entries;
public:
    SymTab(std::string scope, std::string id);

    bool add(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, bool hasScope);

    Entry* search(std::string id);
    int hashFuntion(std::string id);
};

SymTab::SymTab(std::string scope, std::string id){
//     this->table = new std::unordered_map<std::string, Entry*>();
    this->scope = scope;
    this->id = id;
//     this->entries = new std::vector<Entry>();
}

bool SymTab::add(std::string id, std::string type, std::string dataType, std::string scope, int lineNum, bool hasScope){
    Entry *newSymbol = new Entry(id, type, dataType, scope, lineNum, hasScope);
    table.insert(make_pair(id, newSymbol));
    return true;
}

Entry* SymTab::search(std::string id){
    if(table.count(id) > 0){
        return table.at(id);
    }
    return nullptr;
}

int SymTab::hashFuntion(std::string id){
    return 0;
}

#endif
