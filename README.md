#include <iostream>

using namespace std;

int sum (int n, int m, int **a)
{
    int s = 0;
    for (int i = 0; i < n; i++)
    {
        for (int k = 0; k < m; k ++)
            if (a[i][k] > 0)
                s = s + a[i][k];
                    }
    cout << endl;
    return s;
}

int main()
{
    int n;
    int m;
    cout << "Введите размерность массива: n = "; 
    cin >> n; 
    cout << " m = "; 
    cin >> m;
    cout << endl;
    int **a = new int *[n];
       for (int i = 0; i < n; i++)
        a[i] = new int [m];
    for (int i = 0; i < n; i++)
    {
            for (int k = 0; k < m; k ++)
            cin >> a[i][k];
    }
    for (int i = 0; i < n; i++)
    {
        for (int k = 0; k < m; k ++)
            cout << a[i][k] << ' ';
        cout << endl;
    }
    cout << "Сумма положительных элементов массива равна " << sum (n, m, a);
    return 0;
}
