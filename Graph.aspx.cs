using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Graph
{
    public partial class Graph : System.Web.UI.Page
    {
        protected string CompanyID;
        protected string BranchID;
        protected string DepartmentID;
        protected string EmployeeID;
        protected string ConnectionString;

        public class PartographData
        {
            public string fetalHeartRateData { get; set; }
            public string cervicalDilationData { get; set; }
            public string headDescentData { get; set; }
            public string TempData { get; set; }
            public string PulseData { get; set; }
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            Hashtable SessionKey = (Hashtable)Session["SessionKey"];
            if (SessionKey == null)
            {
                Response.Redirect("reporterror.htm");
            }
            CompanyID = SessionKey["CompanyID"].ToString();
            BranchID = SessionKey["BranchID"].ToString();
            DepartmentID = SessionKey["DepartmentID"].ToString();
            EmployeeID = SessionKey["EmployeeID"].ToString();
            //ConnectionString = TraceBizCommon.Configuration.ConfigSettings.ConnectionString; Insert your connection string

            PartographData partographData = LoadPartograph();
            string partographDataJSON = JsonConvert.SerializeObject(partographData);
            partographDataHiddenField.Value = partographDataJSON;
            Page.ClientScript.RegisterStartupScript(this.GetType(), "partographData", "var partographData = " + partographDataJSON + ";", true);
        }

        protected PartographData LoadPartograph()
        {
            //string connectionString = TraceBizCommon.Configuration.ConfigSettings.ConnectionString;
            List<int> fetalHeartRateData = new List<int>();
            List<int> cervicalDilationData = new List<int>();
            List<int> headDescentData = new List<int>();
            List<int> TempData = new List<int>();
            List<int> PulseData = new List<int>();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("enterprise.PatientPartograph", connection))//This is your stored procedure that populates the graph
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@CompanyID", SqlDbType.NVarChar).Value = CompanyID;
                    command.Parameters.Add("@BranchID", SqlDbType.NVarChar).Value = BranchID;
                    command.Parameters.Add("@DepartmentID", SqlDbType.NVarChar).Value = DepartmentID;
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            fetalHeartRateData.Add(Convert.ToInt32(reader["FetalPulse"]));
                            cervicalDilationData.Add(Convert.ToInt32(reader["Cervix"]));
                            headDescentData.Add(Convert.ToInt32(reader["HeadDescent"]));
                            TempData.Add(Convert.ToInt32(reader["Temp"]));
                            PulseData.Add(Convert.ToInt32(reader["PT_Pulse"]));
                        }
                    }
                }
            }

            return new PartographData
            {
                fetalHeartRateData = JsonConvert.SerializeObject(fetalHeartRateData),
                cervicalDilationData = JsonConvert.SerializeObject(cervicalDilationData),
                headDescentData = JsonConvert.SerializeObject(headDescentData),
                TempData = JsonConvert.SerializeObject(TempData),
                PulseData = JsonConvert.SerializeObject(PulseData)
            };
        }
    }
}