<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Graph.aspx.cs" Inherits="Graph.Graph" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%--<%@ Import Namespace="TraceBizCommon.Configuration" %>--%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html>
<head>
    <title>Partograph Charts</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div style="display: flex; flex-direction: column;">
        <div>
            <canvas id="fetalHeartRateChart" width="100" height="300"></canvas>
        </div>
        <div>
            <canvas id="cervicalDescentChart" width="100" height="300"></canvas>
        </div>
         <div>
            <canvas id="VitalsChart" width="100" height="300"></canvas>
        </div>
    </div>
    <input type="hidden" id="partographDataHiddenField" runat="server" />
     <script>
         const labels = ['0h', '1h', '2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', '10h', '11h', '12h'];


         var hiddenField = document.getElementById('<%= partographDataHiddenField.ClientID %>');

         function populateCharts() {
             var partographData = hiddenField.value;
             /* console.log(partographData)*/
             var parsedPartographData = JSON.parse(partographData);

             var FetalHeartRateData = JSON.parse(parsedPartographData.fetalHeartRateData);
             var CervicalDilationData = JSON.parse(parsedPartographData.cervicalDilationData);
             var HeadDescentData = JSON.parse(parsedPartographData.headDescentData);
             var TempData = JSON.parse(parsedPartographData.TempData);
             var PulseData = JSON.parse(parsedPartographData.PulseData);
             //console.log(TempData)
             //console.log(PulseData)
             new Chart(document.getElementById('fetalHeartRateChart').getContext('2d'), {


                 type: 'line',
                 data: {
                     labels: labels,
                     datasets: [{
                         label: 'Fetal Heart Rate',
                         data: FetalHeartRateData,
                         borderColor: 'rgba(75, 192, 192, 1)',
                         fill: false
                     }]
                 },
                 options: {
                     responsive: true,
                     maintainAspectRatio: false
                 }
             });
             new Chart(document.getElementById('cervicalDescentChart').getContext('2d'), {
                 type: 'line',
                 data: {
                     labels: labels,
                     datasets: [
                         {
                             label: 'Cervical Dilation',
                             data: CervicalDilationData,
                             borderColor: 'rgba(255, 99, 132, 1)',
                             fill: false
                         },
                         {
                             label: 'Head Descent',
                             data: HeadDescentData,
                             borderColor: 'rgba(54, 162, 235, 1)',
                             fill: false
                         },
                         {
                             label: 'Alert Line',
                             data: [
                                 { x: '0h', y: 4 },
                                 { x: '6h', y: 10 }
                             ],
                             borderColor: 'rgba(0, 0, 0, 1)',
                             borderWidth: 2,
                             borderDash: [5],
                             fill: false
                         },
                         {
                             label: 'Action Line',
                             data: [
                                 { x: '4h', y: 4 },
                                 { x: '10h', y: 10 }
                             ],
                             borderColor: 'rgba(0, 255, 0, 1)',
                             borderWidth: 2,
                             borderDash: [5],
                             fill: false
                         }
                     ]
                 },
                 options: {
                     responsive: true,
                     maintainAspectRatio: false
                 }
             });


             new Chart(document.getElementById('VitalsChart').getContext('2d'), {
                 type: 'line',
                 data: {
                     labels: labels,
                     datasets: [{
                         label: 'Temperature',
                         data: TempData,
                         borderColor: 'rgba(255, 99, 132, 1)',
                         /*  backgroundColor: 'rgba(255, 99, 132, 0.2)',*/
                         fill: false
                     },
                     {
                         label: 'Pulse',
                         data: PulseData,
                         borderColor: 'rgba(54, 162, 235, 1)',
                         //backgroundColor: 'rgba(54, 162, 235, 0.2)',
                         fill: false
                     }]
                 },
                 options: {
                     responsive: true,
                     maintainAspectRatio: false
                 }
             });
         }
         document.addEventListener("DOMContentLoaded", function () {
             populateCharts();
         });

     </script>
</body>
</html>


