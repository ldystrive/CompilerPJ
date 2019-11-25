#ifndef _TREE_H_
#define _TREE_H_

#include<vector>
#include<string>
#include<stdarg.h>
#include<iostream>
using std::string;
using std::vector;
using std::cout;
using std::endl;
class Node{
public:
    vector<Node*> child;
    string tokenType,value;
    bool is_leaf;
    bool is_visible;
    int first_line,first_column,last_line,last_column;
    Node(string tokenType,int num,...):tokenType(tokenType),is_leaf(false),is_visible(true)
    {
        va_list ap;
        va_start(ap,num);
        for(int i=0;i<num;i++)
        {
            Node* ch=va_arg(ap,Node*);
            this->child.push_back(ch);
        }
        if(!num)
            return;
        this->first_line=this->child.front()->first_line;
        this->first_column=this->child.front()->first_column;
        this->last_line=this->child.back()->last_line;
        this->last_column=this->child.back()->last_column;

    }

    Node(string tokenType,string value,int first_line,int first_column,int last_line,int last_column):tokenType(tokenType),value(value),is_leaf(true),is_visible(true),first_line(first_line),first_column(first_column),last_line(last_line),last_column(last_column){}
    ~Node()
    {
        for(auto ch:this->child)
            delete ch;
    }
    Node* show()
    {
        Node* root=new Node(this->tokenType,0);
        root->value=this->value;
        root->is_leaf=this->is_leaf;
        root->is_visible=this->is_visible;
        root->first_line=this->first_line;
        root->first_column=this->first_column;
        root->last_line=this->last_line;
        root->last_column=this->last_column;
        for(auto ch:this->child)
        {
            Node* tmp=ch->show();
            //cout<<"debug: "<<tmp->tokenType<<" "<<tmp->is_visible<<endl;
            if(!tmp->is_visible)
            {
                for(auto chch:tmp->child)
                {
                    root->child.push_back(chch);
                }
                tmp->child.clear();
                delete tmp;
            }
            else
                root->child.push_back(tmp);
        }
        return root;
    }
    Node* invisible()
    {
        this->is_visible=false;
        return this;
    }
    Node* visible()
    {
        this->is_visible=true;
        return this;
    }
    string position()
    {
        return " at ( "+std::to_string(this->first_line)+", "+std::to_string(this->first_column)+", "+std::to_string(this->last_line)+", "+std::to_string(this->last_column)+")";
    }
    void print(string indent)
    {
        std::cout<<indent<<this->tokenType<<this->position()<<(this->is_leaf?" "+this->value:"")<<std::endl;
        for(auto ch:this->child)
            ch->print(indent+"\t");
    }
};
#endif
/*
int main()
{
    Node* head[1010];
    head[0]=new Node("Hello","0");
    head[1]=new Node("World","1");
    head[2]=new Node("!","2");
    head[3]=new Node("Hello world!",3,head[0],head[1],head[2]);
    head[4]=new Node("I","4");
    head[5]=new Node("give up","5");
    head[6]=new Node("!","6");
    head[7]=new Node("I give up!",3,head[4],head[5],head[6]);
    head[8]=new Node("Fuck C++!",2,head[3],head[7]);
    head[3]->invisible();
    head[6]->invisible();
    head[9]=head[8]->show();
    head[9]->print("");
    return 0;
}
*/