using System;
using System.Collections.Generic;
using System.Text;

namespace Dul
{
    public static class StringLibrary
    {
        public static string CutString(this string strCut, int intChar)
        {
            if(strCut.Length > (intChar - 3))
            {
                return strCut.Substring(0, intChar - 3) + "...";
            }
            return strCut;
        }
        public static string CutStringUnicode(this string str, int length)
        {
            string result = str;

            var si = new System.Globalization.StringInfo(str);
            var l = si.LengthInTextElements;

            if(l > (length - 3))
            {
                result= si.SubstringByTextElements(0, length - 3) + "...";

            }
            return result;
        }
    }
}
