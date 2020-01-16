using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Excel;
using Excel = Microsoft.Office.Interop.Excel;

namespace wojewodztwa
{

    



    class Program
    {


        

        static void Main(string[] args)
        {

            int funkcja(int param)
            {
                int wynik = 0;


                switch (param)
                {
                    case 3:
                        wynik = 9;
                        break;
                    case 4:
                        wynik = 7;
                        break;
                    case 5:
                        wynik = 16;
                        break;
                    case 6:
                        wynik = 17;
                        break;
                    case 7:
                        wynik = 14;
                        break;
                    case 8:
                        wynik = 11;
                        break;
                    case 9:
                        wynik = 15;
                        break;
                    case 10:
                        wynik = 3;
                        break;
                    case 11:
                        wynik = 10;
                        break;
                    case 12:
                        wynik = 8;
                        break;
                    case 13:
                        wynik = 12;
                        break;
                    case 14:
                        wynik = 2;
                        break;
                    case 15:
                        wynik = 6;
                        break;
                    case 16:
                        wynik = 13;
                        break;
                    case 17:
                        wynik = 4;
                        break;
                    case 18:
                        wynik = 5;
                        break;


                }





                return wynik;
            }



            string[] nazwy = { "slaskie", "opolskie", "wielkopolskie", "zachodniopomorskie", "swietokrzyskie",
                                "kujawsko-pomorskie", "podlaskie", "dolnoslaskie", "podkarpackie", "malopolskie",
                                "pomorskie", "warminsko-mazurskie", "lodzkie", "mazowieckie", "lubelskie", "lubuskie" };


            Dictionary<string,int> imiona = new Dictionary<string, int>();



            Excel.Application app = new Excel.Application();

            Excel.Workbook workbook1;
            Excel.Workbook workbook2;

            workbook1 = app.Workbooks.Open("C:\\Users\\Radek\\Desktop\\imiona_2017.xlsx");
            workbook2 = app.Workbooks.Open("C:\\Users\\Radek\\Desktop\\im_2017.xlsx");

            Excel.Worksheet input;
            Excel.Worksheet output = workbook2.Sheets[1];
            Console.WriteLine("Wpisywanie woj");
            for(int i = 0; i < nazwy.Length; i++)
            {
                output.Cells[2 + i, 1].Value = nazwy[i];
            }
            Console.WriteLine("Szukanie imion");
            int it = 3;
            int pomoc = 2;
            for(int i=3; i <= workbook1.Sheets.Count; i++)
            {
                input = workbook1.Sheets[i];
                it = 3;
                while (input.Cells[it,2].Value != null)
                {
                    if(imiona.ContainsKey((input.Cells[it, 2].Value)) == false)
                    {
                        imiona.Add(input.Cells[it, 2].Value,pomoc);
                        pomoc++;
                    }
                    it++;
                }

                it = 3;
                
                while(input.Cells[it,7].Value != null)
                {
                    if (imiona.ContainsKey(input.Cells[it, 7].Value) == false)
                    {
                        imiona.Add(input.Cells[it, 7].Value,pomoc);
                        pomoc++;
                    }
                    it++;
                }



            }

            Console.WriteLine("Wpisywanie imion");
            int wypisz = 2;
            foreach(string imie in imiona.Keys)
            {
                output.Cells[1, wypisz].Value = imie;
                wypisz++;
            }


            Console.WriteLine("Wpisywanie zer");
            for (int i = 2; i < nazwy.Length + 2; i++)
            {
                for (int j = 2; j < imiona.Count + 2; j++)
                {
                    output.Cells[i, j].value = 0;
                }
            }


            Console.WriteLine("Wpisywanie liczb");

            for (int i = 3; i <= workbook1.Sheets.Count; i++)
            {
                Console.WriteLine("sheet {0}",i);
                input = workbook1.Sheets[i];
                it = 3;
                while (input.Cells[it, 2].Value != null)
                {
                    
                    output.Cells[funkcja(i), imiona[input.Cells[it, 2].Value]].Value = input.Cells[it, 3].Value;
                    


                    it++;
                }

                it = 3;
                while (input.Cells[it, 7].Value != null)
                {


                    output.Cells[funkcja(i), imiona[input.Cells[it, 7].Value]].Value = input.Cells[it, 8].Value;

                   


                    it++;
                }










            }





            workbook1.Close(true);
            workbook2.Close(true);

            app.Quit();

            Marshal.ReleaseComObject(app);


        }
    }
}
