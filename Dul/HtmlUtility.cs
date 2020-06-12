using System;
using System.Collections.Generic;
using System.Text;

namespace Dul
{
    public class HtmlUtility
    {
        #region
        public static string Encode(string strContent)
        {
            string strTemp = "";
            if (String.IsNullOrEmpty(strContent))
            {
                strTemp = "";
            }
            else
            {
                strTemp = strContent;
                strTemp = strTemp.Replace("&", "&amp;");
                strTemp = strTemp.Replace(">", "&gt;");
                strTemp = strTemp.Replace("<", "&lt;");
                strTemp = strTemp.Replace("\r\n", "<br />");
                strTemp = strTemp.Replace("\"", "&#34;");
            }
            return strTemp;
        }
        #endregion

        #region
        public static string EncodeWithTabAndSpace(string strContent)
        {
            return Encode(strContent).Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;").Replace(" " + " ", "&nbsp;&nbsp;");
        }
        #endregion
    }
}
