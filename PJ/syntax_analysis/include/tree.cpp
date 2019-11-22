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
    Node(string tokenType,int num,...):tokenType(tokenType),is_leaf(false),is_visible(true)
    {
        va_list ap;
        va_start(ap,num);
        for(int i=0;i<num;i++)
        {
            Node* ch=va_arg(ap,Node*);
            this->child.push_back(ch);
        }
    }

    Node(string tokenType,string value):tokenType(tokenType),value(value),is_leaf(true),is_visible(true){}
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
    void print(string indent)
    {
        std::cout<<indent<<this->tokenType<<(this->is_leaf?" "+this->value:"")<<std::endl;
        for(auto ch:this->child)
            ch->print(indent+"\t");
    }
};
#endif
#define debug
#ifdef debug
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
#endif