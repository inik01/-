#include <iostream>

using namespace std;

string txt (string text)
{
    char x[text.length()];
    for (int i = 0; i < text.length(); i++)
        x[i] = text[i];
    for (int i = 0; i < text.length(); i++)
        if (x[i] == 39)
            x[i] = ' ';
    for (int i = 0; i < text.length(); i++)
        if ((x[i] >= 33 && x[i] < 48 && x[i]) || (x[i] > 57 && x[i] < 64))
            x[i] = ' ';
    for (int i = 0; i < text.length(); i++)
        if (x[i] > 64 && x[i] < 91)
            x[i] = x[i] + 32;
    for (int i = 0; i < text.length(); i++)
        text[i] = x[i];
    return text;
}

int main()
{
    string text;
    int n;
    cout << "Введите текст: " << endl;
    getline (cin, text);
    text = txt (text);
    int spc = 0;
    int i;
    int k;
    for (i = 0; i < text.length(); i++) // узнаем, сколько слов
        if (text[i] == ' ')
            k += 1;
    n = k + 1; 
    string vocab[n]; // массив всех слов текста
    string p;
    int ind = 0;
    for (i = 0; i < text.length(); i++)
    {
        if (text[i] != ' ')
            p += text[i];
        else 
            if (text[i + 1] != ' ')
            {
                vocab[ind] = p;
                p.clear();
                ind++;
            }
    }
    p.clear();
    while (text[i] != ' ') // Последнее слово в массив
        i--;
    for (k = i + 1; k < text.length(); k++)
        p += text[k];
    vocab[ind] = p;
    for (i = 0; i < n; i++)
    {
        if (vocab[i].length() == 0)
            spc++;
    }
    n -= spc;
    string zapas[n];
    for (i = 0; i < n; i++)
        zapas[i] = vocab[i];
    int kol = 0; // количество не одинарных слов 
    for (i = 0; i < n; i++)
    {
        int j = 0; // сколько раз слово повторилось в тексте
        for (k = i + 1; k < n; k++)
            if (vocab[i] == vocab[k])
            {
                j++;
                vocab[k] = k;
            }
        if (j > 0)
        {
            kol++;
        }
        else
            vocab[i] = "del."; // убираем одинарные слова
    }
    string slovar[kol + 1][2];
    int q = 0;
    for (i = 0; i < n; i++)
        if (vocab[i] != "del.")
        {
            slovar[q][0] = vocab[i];
            q++;
        }
    int num;
    for (q = 0; q < kol; q++)
    {
        num = 0;
        for (i = 0; i < n; i++)
            if (slovar[q][0] == zapas[i])
                num++;
        slovar[q][1] = to_string(num);
    }
    cout << endl;
    for (i = 0; i < kol; i++)
        cout << slovar[i][0] << " [" << slovar[i][1] << "] " << endl;
    return 0;
}
