using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Office.Interop.Excel;
using Excel = Microsoft.Office.Interop.Excel;

namespace przerobka
{
    class Program
    {
        static void Main(string[] args)
        {

            Excel.Application app = new Excel.Application();

            Excel.Workbook workbook1;
            workbook1 = app.Workbooks.Open("C:\\Imiona\\Imiona\\im_2017.xlsx");
            Excel.Worksheet input = workbook1.Sheets[1];

            int i = 2;
            string imie;
            while (input.Cells[1, i].Value != null)
            {
                Console.WriteLine("Imie nr{0}", i);
                imie = input.Cells[1, i].Value;
                imie = imie.Replace("Ł", "L");
                imie = imie.Replace("Ą", "A");
                imie = imie.Replace("Ę", "E");
                imie = imie.Replace("Ć", "C");
                imie = imie.Replace("Ń", "N");
                imie = imie.Replace("Ó", "O");
                imie = imie.Replace("Ś", "S");
                imie = imie.Replace("Ź", "Z");
                imie = imie.Replace("Ż", "Z");
                input.Cells[1, i].Value = imie;

                i++;
            }

            Console.WriteLine("DONE");
            




            Console.ReadKey();



            workbook1.Close(true);
            app.Quit();

            Marshal.ReleaseComObject(app);

        }
    }
}
