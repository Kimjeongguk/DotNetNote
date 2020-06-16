using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MemoEngine.DotNetNote.Controls
{
    public partial class AdvancedPagingSingleWithBootstrap : System.Web.UI.UserControl
    {
        public bool SearchMode { get; set; }
        public string SearchField { get; set; }
        public string SearchQuery { get; set; }
        [Category("페이징처리")]
        public int PageIndex { get; set; }

        [Category("페이징처리")]
        public int PageCount { get; set; }

        [Category("페이징처리")]
        [Description("한 페이지에 몇 개의 레코드를 보여줄 건지 결정")]
        public int PageSize { get; set; } = 10;

        private int _RecordCount;

        [Category("페이징처리")]
        [Description("현재 테이블에 몇 개의 레코드가 있는지 지정")]
        public int RecordCount
        {
            get { return _RecordCount; }
            set
            {
                _RecordCount = value;
                PageCount = ((_RecordCount - 1) / PageSize) + 1;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            SearchMode = (!string.IsNullOrEmpty(Request.QueryString["SearchField"]) && !string.IsNullOrEmpty(Request.QueryString["SearchQuery"]));

            if (SearchMode)
            {
                SearchField = Request.QueryString["SearhcField"];
                SearchQuery = Request.QueryString["SearchQuery"];
            }

            ++PageIndex;
            int i = 0;

            string strPage = "<ul class='pagination pagination-sm'>";
            if(PageIndex > 10)
            {
                if (SearchMode)
                {
                    strPage += "<li><a href=\""
                        + Request.ServerVariables["SCRIPT_NAME"]
                        + "?Page="
                        + Convert.ToString((PageIndex - 1) / (int)10 * 10)
                        + "&SearchField=" + SearchField
                        + "&SearchQuery=" +SearchQuery + "\">◀</a></li>";
                }
                else
                {
                    strPage += "<li><a href=\""
                        + Request.ServerVariables["SCRIPT_NAME"]
                        + "?Page="
                        + Convert.ToString((PageIndex - 1) / (int)10 * 10)
                        + "\">◀</a></li>";
                }
            }
            else
            {
                strPage += "<li class=\"disabled\"><a>◁</a></li>";
            }

            for(i=(((PageIndex -1) / (int)10) * 10 + 1); i<=((((PageIndex -1)/(int)10) + 1) *10); i++)
            {
                if (i > PageCount) { break; }
                if (i == PageIndex)
                {
                    strPage += " <li class='active'><a href='#'>"
                        + i.ToString() + "</a></li>";
                }
                else
                {
                    if (SearchMode)
                    {
                        strPage += "<li><a href=\""
                            + Request.ServerVariables["SCRIPT_NAME"]
                            + "?Page=" + i.ToString()
                            + "&SearchField=" + SearchField
                            + "&SearchQuery=" + SearchQuery + "\">"
                            + i.ToString() + "</a></li>";
                    }
                    else
                    {
                        strPage += "<li><a href=\""
                        + Request.ServerVariables["SCRIPT_NAME"]
                        + "?Page=" + i.ToString() + "\">"
                            + i.ToString() + "</a></li>";
                    }
                }
            }

            if (i < PageCount)
            {
                if (SearchMode)
                {
                    strPage += "<li><a href=\""
                        + Request.ServerVariables["SCRIPT_NAME"]
                        + "?Page="
                        + Convert.ToString(((PageIndex - 1) / (int)10) * 10 + 11)
                        + "&SearchField=" + SearchField
                        + "&SearchQuery=" + SearchQuery + "\">▶</a></li>";
                }
                else
                {
                    strPage += "<li><a href=\""
                        + Request.ServerVariables["SCRIPT_NAME"]
                        + "?Page="
                        + Convert.ToString(((PageIndex - 1) / (int)10) * 10 + 11)
                        + "\">▶</a></li>";
                }
            }
            else
            {
                strPage += "<li class=\"disabled\"><a>▷</a></li>";
            }

            strPage += "</ul>";

            ctlAdvancedPaingWithBootstrap.Text = strPage;
        }
    }
}