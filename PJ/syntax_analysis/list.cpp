#include<bits/stdc++.h>
using namespace std;
void print(string s)
{
    cout<<s<<"-list:"<<endl;
    cout<<"\t%empty {$$ = new Node(\""<<s<<"-list"<<"\",\"\");}"<<endl;
    cout<<"\t"<<s<<" "<<s<<"-list {$$ = new Node(\""<<s<<"-list\""<<",2,$1,$2->invisible());}"<<endl;
    cout<<"\t;"<<endl;
}
void print(string s,string sep)
{
    cout<<s<<"-non-null-list:"<<endl;
    cout<<"\t"<<s<<" "<<s<<"-trail {$$ = new Node(\""<<s<<"-non-null-list\""<<",2,$1,$2->invisible());}"<<endl;
    cout<<"\t;"<<endl;
    cout<<s<<"-trail:"<<endl;
    cout<<"\t%empty {$$ = new Node(\""<<s<<"-trail"<<"\",\"\");}"<<endl;
    cout<<"\t| "<<sep<<" "<<s<<" "<<s<<"-trail {$$ = new Node(\""<<s<<"-trail\""<<",3,$1,$2,$3->invisible());}"<<endl;
    cout<<"\t;"<<endl;

}
int main(int args,char* argv[])
{
    string s;
    string sep;
    if(args==4)
    {
        s=string(argv[2]);
        sep=string(argv[3]);
        print(s,sep);
        return 0;
    }
    if(args==2)
    {
        s=string(argv[1]);
        print(s);
        return 0;
    }
    while(1)
    {
        cin>>s;
        if(s=="!")
        {
            cin>>s>>sep;
            print(s,sep);
        }
        else
            print(s);
    }
}
