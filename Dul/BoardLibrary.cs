using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Dul
{
    public class BoardLibrary
    {
        #region

        public static string FuncStrp(object objStep)
        {
            int intStep = Convert.ToInt32(objStep);
            string strTemp = String.Empty;
            if(intStep == 0)
            {
                strTemp = String.Empty;
            }
            else
            {
                for(int i =0; i< intStep; i++)
                {
                    strTemp = String.Format(
                        "<img src=\"{0}\" height=\"{1}\" width=\"{2}\">",
                        "/images/dnn/blank.gif", "0", (intStep * 15));
                }
                strTemp += "<img src=\"/images/dnn/re.gif\">";
            }
            return strTemp;
        }
        #endregion

        #region

        public static string ShowCommentCount(object objCommentCount)
        {
            string strTemp = "";
            try
            {
                if(Convert.ToInt32(objCommentCount) > 0)
                {
                    strTemp = "<img src=\"imges/dnn.commentcount.gif\" />";
                    strTemp = "(" + objCommentCount.ToString() + ")";
                }
            }
            catch(Exception)
            {
                strTemp = "";
            }
            return strTemp;
        }
        #endregion

        #region

        public static string FuncNew(object strDate)
        {
            if(strDate != null)
            {
                if (!String.IsNullOrEmpty(strDate.ToString()))
                {
                    DateTime originDate = Convert.ToDateTime(strDate);

                    TimeSpan objTs = DateTime.Now - originDate;
                    string newImage = "";
                    if(objTs.TotalMinutes < 1400)
                    {
                        newImage = "<img src=\"/images/dnn/new.gif\">";
                    }
                    return newImage;
                }
            }
            return "";
        }
        #endregion

        #region

        public static string FunShowTime(object date)
        {
            if (date != null)
            {
                if (!String.IsNullOrEmpty(date.ToString()))
                {
                    string strPostDate = Convert.ToDateTime(date).ToString("yyyy-MM-dd");
                    if (strPostDate == DateTime.Now.ToString("yyyy-MM-dd"))
                    {
                        return Convert.ToDateTime(date).ToString("hh:mm:ss");
                    }
                    else
                    {
                        return strPostDate;
                    }
                }
            }
            return "-";
        }
        #endregion

        #region

        public static string ConvertToFileSize(int intByte)
        {
            int intFileSize = Convert.ToInt32(intByte);
            string strResult = "";
            if(intFileSize >= 1048576)
            {
                strResult = string.Format("{0:F} MB", (intByte / 1048576));
            }
            else
            {
                if (intFileSize >= 1024)
                {
                    strResult = string.Format("{0} KB", (intByte / 1024));
                }
                else
                {
                    strResult = intByte + "Byte(s)";
                }
            }
            return strResult;
        }
        #endregion

        #region 

        public static bool IsPhoto(string strFileNameTemp)
        {
            string ext = Path.GetExtension(strFileNameTemp).Replace(".", "").ToLower();
            bool blnResult = false;
            if (ext == "gif" || ext == "jpg" || ext == "jpeg" || ext == "png")
            {
                blnResult = true;
            }
            else
            {
                blnResult = false;
            }
            return blnResult;
        }
        #endregion

        #region 

        public static string FuncFileDownsingl(int id, string strFileName, string strFileSize)
        {
            if(strFileName.Length > 0)
            {
                return "<a href=\"/DotNetNote/BoardDown.aspx?Id=" +
                    id.ToString() + "\">" +
                    DownloadType(strFileName, strFileName + "(" +
                    ConvertToFileSize(Convert.ToInt32(strFileSize)) + ")") +
                    "</a>";
            }
            else
            {
                return "-";
            }
        }
        #endregion

        #region 

        public static string DownloadType(string strFileName, string altString)
        {
            string strFileExt = Path.GetExtension(strFileName).Replace(".", "").ToLower();
            string r = "";

            switch (strFileExt)
            {
                case "bmp":
                    r = "<img src='/images/ext/ext_bmp.gif' border='0' alt=" + altString + ">";
                    break;
                case "css":
                    r = "<img src='/images/ext/ext_css.gif' border='0' alt=" + altString + ">";
                    break;
                case "gif":
                    r = "<img src='/images/ext/ext_gif.gif' border='0' alt=" + altString + ">";
                    break;
                case "htm":
                    r = "<img src='/images/ext/ext_htm.gif' border='0' alt=" + altString + ">";
                    break;
                case "html":
                    r = "<img src='/images/ext/ext_html.gif' border='0' alt=" + altString + ">";
                    break;
                case "jpg":
                    r = "<img src='/images/ext/ext_jpg.gif' border='0' alt=" + altString + ">";
                    break;
                case "jpeg":
                    r = "<img src='/images/ext/ext_jpeg.gif' border='0' alt=" + altString + ">";
                    break;
                case "js":
                    r = "<img src='/images/ext/ext_js.gif' border='0' alt=" + altString + ">";
                    break;
                case "":
                    r = "<img src='/images/ext/ext_none.gif' border='0' alt=" + altString + ">";
                    break;
                case "png":
                    r = "<img src='/images/ext/ext_png.gif' border='0' alt=" + altString + ">";
                    break;
                case "sql":
                    r = "<img src='/images/ext/ext_sql.gif' border='0' alt=" + altString + ">";
                    break;
                case "txt":
                    r = "<img src='/images/ext/ext_txt.gif' border='0' alt=" + altString + ">";
                    break;
                case "zip":
                    r = "<img src='/images/ext/ext_zip.gif' border='0' alt=" + altString + ">";
                    break;
                default:
                    r = "<img src='/images/ext/ext_unkown.gif' border='0' alt=" + altString + ">";
                    break;
            }
            return r;
        }
        #endregion

    }
}
