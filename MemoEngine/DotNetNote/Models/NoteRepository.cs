using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dapper;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace MemoEngine.DotNetNote.Models
{
    public class NoteRepository
    {
        private SqlConnection con;

        public NoteRepository()
        {
            con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionsString"].ConnectionString);
        }

        public int SaveOrUpdate(Note n, BoardWriteFormType formType)
        {
            int r = 0;

            var p = new DynamicParameters();

            p.Add("@Name", value: n.Name, dbType: DbType.String);
            p.Add("@Email", value: n.Email, dbType: DbType.String);
            p.Add("@Title", value: n.Title, dbType: DbType.String);
            p.Add("@Content", value: n.Content, dbType: DbType.String);
            p.Add("@Password", value: n.Password, dbType: DbType.String);
            p.Add("@Encoding", value: n.Encoding, dbType: DbType.String);
            p.Add("@Homepage", value: n.Homepage, dbType: DbType.String);
            p.Add("@FileName", value: n.FileName, dbType: DbType.String);
            p.Add("@FileSize", value: n.FileSize, dbType: DbType.String);

            switch (formType)
            {
                case BoardWriteFormType.Write:
                    p.Add("@PostIp", value: n.PostIp, dbType: DbType.String);

                    r = con.Execute("WriteNote", p, commandType: CommandType.StoredProcedure);
                    break;
                case BoardWriteFormType.Modify:
                    p.Add("@ModifyIp", value: n.ModifyIp, dbType: DbType.String);

                    r = con.Execute("ModifyNote", p, commandType: CommandType.StoredProcedure);
                    break;
                case BoardWriteFormType.Reply:
                    p.Add("PostIp", value: n.PostIp, dbType: DbType.String);
                    p.Add("@ParentNum", value: n.ParentNum, dbType: DbType.Int32);

                    r = con.Execute("ReplyNote", p, commandType: CommandType.StoredProcedure);
                    break;
            }
            return r;
        }

        public void Add(Note vm)
        {
            try
            {
                SaveOrUpdate(vm, BoardWriteFormType.Write);
            }
            catch(System.Exception ex)
            {
                throw new System.Exception(ex.Message);
            }
        }

        public int UpdateNote(Note vm)
        {
            int r = 0;
            try
            {
                r = SaveOrUpdate(vm, BoardWriteFormType.Modify);
            }
            catch(System.Exception ex)
            {
                throw new System.Exception(ex.Message);
            }
            return r;
        }

        public void ReplyNote(Note vm)
        {
            try
            {
                SaveOrUpdate(vm, BoardWriteFormType.Reply);
            }
            catch(System.Exception ex)
            {
                throw new System.Exception(ex.Message);
            }
        }

        public List<Note> GetAll(int page)
        {
            try
            {
                var parameters = new DynamicParameters(new { Page = page });
                return con.Query<Note>("ListNotes", parameters, commandType: CommandType.StoredProcedure).ToList();
            }
            catch(System.Exception ex)
            {
                throw new System.Exception(ex.Message);
            }
        }

        public int GetCountBySearch(string searchField, string searchQuery)
        {
            try
            {
                return con.Query<int>("SearchNoteCount", new
                {
                    SearchField = searchField,
                    SearchQuery = searchQuery
                },
                    commandType: CommandType.StoredProcedure)
                    .SingleOrDefault();
            }
            catch(System.Exception ex)
            {
                throw new System.Exception(ex.Message);
            }
        }

        public int GetCountAll()
        {
            try
            {
                return con.Query<int>("Select Count(*) From Notes").SingleOrDefault();
            }
            catch (System.Exception)
            {
                return -1;
            }
        }

        public string GetFileNameById(int id)
        {
            return con.Query<string>("Select FileName From Notes Where Id = @Id", new { Id = id }).SingleOrDefault();
        }

        public List<Note> GetSearchAll(int page, string searchField, string searchQuery)
        {
            var parameters = new DynamicParameters(new
            {
                Page = page,
                SearchField = searchField,
                SearchQuery = searchQuery
            });
            return con.Query<Note>("SearchNotes", parameters, commandType: CommandType.StoredProcedure).ToList();
        }

        public void UpdateDownCount(string fileName)
        {
            con.Execute("Update Notes Set DownCount = DownCount + 1" + " Where FileName = @FileName", new { FileName = fileName });
        }
        
        public void UpdateDownCountById(int id)
        {
            var p = new DynamicParameters(new { Id = id });
            con.Execute("Update Notes Set DownCount = DownCount + 1 " + " Where Id = @Id", p, commandType: CommandType.Text);
        }

        public Note GetNoteById(int id)
        {
            var parameters = new DynamicParameters(new { Id = id });
            return con.Query<Note>("ViewNote", parameters, commandType: CommandType.StoredProcedure).SingleOrDefault();
        }
        public int DeleteNote(int id, string password)
        {
            return con.Execute("DeleteNote", new { Id = id, password = password }, commandType: CommandType.StoredProcedure);
        }

        public List<Note> GetNewPhotos()
        {
            string sql = "SELECT TOP 4 Id, Title, FileName, FileSize FROM Notes"
                + " Where FileName Like '%.png' Or FileName Like '%.jpg' Or "
                + " FileName Like '%.jpeg' Or FileName Like '%.gif' "
                + " Order By Id Desc";
            return con.Query<Note>(sql).ToList();
        }

        public List<Note> GetNOteSummaryByCategory(string category)
        {
            string sql = "SELECT TOP 3 Id, Title, Name, PostDate, FileName, "
                + " FileSize, ReadCount, CommentCount, Step "
                + " FORM Notes "
                + " Where Category = @Category Order By Id Desc";

            return con.Query<Note>(sql, new { Category = category }).ToList();
        }

        public List<Note> GetRecentPosts()
        {
            string sql = "SELECT TOP 3 Id, Title, Name, PostDate FROM Notes "
                + " Order By Id Desc";

            return con.Query<Note>(sql).ToList();
        }
    }
}