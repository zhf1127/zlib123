
namespace OdfPPTXPAddin
{
 
    using System;
    using System.Reflection;
    using Microsoft.Office.Core;
    using System.IO;
    using System.Xml;
    using Extensibility;
    using System.Runtime.InteropServices;
    using System.Collections;
#if WordXP
    using PowerPoint = Microsoft.Office.Interop.PowerPoint;
#else
#endif
    using CleverAge.OdfConverter.OdfConverterLib;
    using Sonata.OdfConverter.OdfPowerpointAddinLib;
    using Microsoft.Win32;
	#region Read me for Add-in installation and setup information.
	// When run, the Add-in wizard prepared the registry for the Add-in.
	// At a later time, if the Add-in becomes unavailable for reasons such as:
	//   1) You moved this project to a computer other than which is was originally created on.
	//   2) You chose 'Yes' when presented with a message asking if you wish to remove the Add-in.
	//   3) Registry corruption.
	// you will need to re-register the Add-in by building the OdfPPTXPAddinSetup project, 
	// right click the project in the Solution Explorer, then choose install.
	#endregion
	
	/// <summary>
	///   The object for implementing an Add-in.
	/// </summary>
	/// <seealso class='IDTExtensibility2' />
	[GuidAttribute("361B5BE1-FBC6-4C18-BC87-CB23908FCCDD"), ProgId("OdfPPTXPAddin.Connect")]
    public class Connect : Object, Extensibility.IDTExtensibility2, IOdfConverter
	{
		/// <summary>
		///		Implements the constructor for the Add-in object.
		///		Place your initialization code within this method.
		/// </summary>
        private string DialogBoxTitle = "ODF Converter";
		public Connect()
		{
            this.addinLib = new Sonata.OdfConverter.Presentation.Addin();
		}

		/// <summary>
		///      Implements the OnConnection method of the IDTExtensibility2 interface.
		///      Receives notification that the Add-in is being loaded.
		/// </summary>
		/// <param term='application'>
		///      Root object of the host application.
		/// </param>
		/// <param term='connectMode'>
		///      Describes how the Add-in is being loaded.
		/// </param>
		/// <param term='addInInst'>
		///      Object representing this Add-in.
		/// </param>
		/// <seealso class='IDTExtensibility2' />
		public void OnConnection(object application, Extensibility.ext_ConnectMode connectMode, object addInInst, ref System.Array custom)
		{
            //applicationObject = application;
            //addInInstance = addInInst;
            this.applicationObject = (PowerPoint.Application)application;

            System.Globalization.CultureInfo ci;
            ci = System.Threading.Thread.CurrentThread.CurrentCulture;
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");

            this.DialogBoxTitle = addinLib.GetString("OdfConverterTitle");
            if (connectMode != Extensibility.ext_ConnectMode.ext_cm_Startup)
            {
                OnStartupComplete(ref custom);
            }
		}

		/// <summary>
		///     Implements the OnDisconnection method of the IDTExtensibility2 interface.
		///     Receives notification that the Add-in is being unloaded.
		/// </summary>
		/// <param term='disconnectMode'>
		///      Describes how the Add-in is being unloaded.
		/// </param>
		/// <param term='custom'>
		///      Array of parameters that are host application specific.
		/// </param>
		/// <seealso class='IDTExtensibility2' />
		public void OnDisconnection(Extensibility.ext_DisconnectMode disconnectMode, ref System.Array custom)
		{
            if (disconnectMode != ext_DisconnectMode.ext_dm_HostShutdown)
            {
                OnBeginShutdown(ref custom);
            }
            this.applicationObject = null;
		}

		/// <summary>
		///      Implements the OnAddInsUpdate method of the IDTExtensibility2 interface.
		///      Receives notification that the collection of Add-ins has changed.
		/// </summary>
		/// <param term='custom'>
		///      Array of parameters that are host application specific.
		/// </param>
		/// <seealso class='IDTExtensibility2' />
		public void OnAddInsUpdate(ref System.Array custom)
		{
		}

		/// <summary>
		///      Implements the OnStartupComplete method of the IDTExtensibility2 interface.
		///      Receives notification that the host application has completed loading.
		/// </summary>
		/// <param term='custom'>
		///      Array of parameters that are host application specific.
		/// </param>
		/// <seealso class='IDTExtensibility2' />
		public void OnStartupComplete(ref System.Array custom)
		{
            CommandBar commandBar1 = applicationObject.CommandBars["File"];

            // Add import button
            try
            {
                // if item already exists, use it (should never happen)
                importButton = (CommandBarButton)commandBar1.Controls[this.addinLib.GetString("OdfImportLabel")];
            }
            catch (Exception)
            {
                // otherwise, create a new one
                importButton = (CommandBarButton)commandBar1.Controls.Add(MsoControlType.msoControlButton, Type.Missing, Type.Missing, 3, true);
            }
            // set item's label
            importButton.Caption = this.addinLib.GetString("OdfImportLabel");
            importButton.Tag = this.addinLib.GetString("OdfImportLabel");
            // set action
            //importButton.OnAction = "!<OdfConverterPPT2003Addin.Connect>";
            importButton.OnAction = "!<OdfPPTXPAddin.Connect>";
            importButton.Visible = true;
            importButton.Click += new Microsoft.Office.Core._CommandBarButtonEvents_ClickEventHandler(this.importButton_Click);

            // Add export button
            try
            {
                // if item already exists, use it (should never happen)
                exportButton = (CommandBarButton)commandBar1.Controls[this.addinLib.GetString("OdfExportLabel")];
            }
            catch (Exception)
            {
                // otherwise, create a new one
                exportButton = (CommandBarButton)commandBar1.Controls.Add(MsoControlType.msoControlButton, Type.Missing, Type.Missing, 4, true);
            }
            // set item's label
            exportButton.Caption = this.addinLib.GetString("OdfExportLabel");
            exportButton.Tag = this.addinLib.GetString("OdfExportLabel");
            // set action
            //exportButton.OnAction = "!<OdfConverterPPT2003Addin.Connect>";
            exportButton.OnAction = "!<OdfPPTXPAddin.Connect>";
            exportButton.Visible = true;
            exportButton.Enabled = true;
            exportButton.Click += new Microsoft.Office.Core._CommandBarButtonEvents_ClickEventHandler(this.exportButton_Click);
		}

        private void importButton_Click(CommandBarButton Ctrl, ref Boolean CancelDefault)
        {
            FileDialog fd = this.applicationObject.get_FileDialog(MsoFileDialogType.msoFileDialogFilePicker);
            // allow multiple file opening
            fd.AllowMultiSelect = true;
            // add filter for ODS files
            fd.Filters.Clear();
            fd.Filters.Add(this.addinLib.GetString("OdfFileType"), "*.odp", Type.Missing);
            fd.Filters.Add(this.addinLib.GetString("AllFileType"), "*.*", Type.Missing);
            // set title
            fd.Title = this.addinLib.GetString("OdfImportLabel");
            // display the dialog
            fd.Show();

            // process the chosen documents	
            for (int i = 1; i <= fd.SelectedItems.Count; ++i)
            {
                // retrieve file name
                String odfFile = fd.SelectedItems.Item(i);

                // create a temporary file
                object fileName = this.addinLib.GetTempFileName(odfFile, ".pptx");

                // setting defaultformat value in registry
                int oldFormat = SetPPTXasDefault();
                // this.applicationObject.System.Cursor = MSExcel.WdCursorType.wdCursorWait;
                OdfToOox(odfFile, (string)fileName, true);
                // this.applicationObject.System.Cursor =  WdCursorType.wdCursorNormal;

                try
                {
                    object readOnly = true;
                    object addToRecentFiles = false;
                    object isVisible = true;
                    object openAndRepair = false;
                    object missing = Missing.Value;

                    // conversion may have been cancelled and file deleted.
                    if (File.Exists((string)fileName))
                    {
                        // Workaround to powerpoint bug. "Old format or invalid type library. (Exception from HRESULT: 0x80028018 (TYPE_E_INVDATAREAD))" 
                        System.Globalization.CultureInfo ci;
                        ci = System.Threading.Thread.CurrentThread.CurrentCulture;
                        System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");

                        PowerPoint.Presentation p = this.applicationObject.Presentations.Open((string)fileName, MsoTriState.msoFalse, MsoTriState.msoFalse, MsoTriState.msoFalse);
                        p.NewWindow();
                        
                    }
                    // removing defaultformat value in registry
                    RestoreDefault(oldFormat);
                }
                catch (Exception ex)
                {
                    // this.applicationObject.System.Cursor = MSExcel.WdCursorType.wdCursorNormal;
                    System.Diagnostics.Debug.WriteLine("*** Exception : " + ex.Message);
                    System.Windows.Forms.MessageBox.Show(addinLib.GetString("OdfUnexpectedError"), DialogBoxTitle, System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Stop);
                    return;
                }
            }
        }

        private void exportButton_Click(CommandBarButton Ctrl, ref Boolean CancelDefault)
        {
            // Workaround to PowerPoint bug. "Old format or invalid type library. (Exception from HRESULT: 0x80028018 (TYPE_E_INVDATAREAD))" 
            System.Globalization.CultureInfo ci;
            ci = System.Threading.Thread.CurrentThread.CurrentCulture;
            try
            {
                System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");
                PowerPoint.Presentation pres = this.applicationObject.ActivePresentation;
                //PowerPoint.Application pptx = new PowerPoint.Application();

                // the second test deals with blank workbooks
                // (which are in a 'saved' state and have no extension yet(?))
                if (pres.FullName.IndexOf('.') < 0)// if (!pptx.Saved || pptx.FullName.IndexOf('.') < 0)
                {
                    System.Windows.Forms.MessageBox.Show(addinLib.GetString("OdfSaveDocumentBeforeExport"), DialogBoxTitle, System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Stop);
                }
                else
                {
                    System.Windows.Forms.SaveFileDialog sfd = new System.Windows.Forms.SaveFileDialog();
                    //sfd.SupportMultiDottedExtensions = true;
                    sfd.AddExtension = true;
                    sfd.DefaultExt = "odp";
                    sfd.Filter = this.addinLib.GetString("OdfFileType") + " (*.odp)|*.odp|"
                            + this.addinLib.GetString("AllFileType") + " (*.*)|*.*";
                    sfd.InitialDirectory = pres.Path;
                    //sfd.OverwritePrompt = true;
                    sfd.Title = this.addinLib.GetString("OdfExportLabel");
                    string ext = '.' + sfd.DefaultExt;
                    sfd.FileName = pres.FullName.Substring(0, pres.FullName.LastIndexOf('.')) + ext;

                    // process the chosen workbooks	
                    if (System.Windows.Forms.DialogResult.OK == sfd.ShowDialog())
                    {
                        // retrieve file name
                        string odfFile = sfd.FileName;
                        if (!odfFile.EndsWith(ext))
                        { // multi dotted extension support
                            odfFile += ext;
                        }
                        object initialName = pres.FullName;
                        object tmpFileName = null;
                        //string pptxFile = (string)initialName;

                        // open the duplicated file
                        object addToRecentFiles = false;
                        object readOnly = false;
                        object isVisible = false;
                        object missing = Missing.Value;

                        // tmpFileName = this.addinLib.GetTempFileName((string)initialName,".ppt");
                        tmpFileName = this.addinLib.GetTempFileName((string)initialName, ".pptx");
                                                
                        OoxToOdf((string)initialName, odfFile, true);


                        if (tmpFileName != null && File.Exists((string)tmpFileName))
                        {
                            this.addinLib.DeleteTempPath((string)tmpFileName);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                // Need to catch a file format exception here.
            }
            finally
            {
                System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            }
        }
		/// <summary>
		///      Implements the OnBeginShutdown method of the IDTExtensibility2 interface.
		///      Receives notification that the host application is being unloaded.
		/// </summary>
		/// <param term='custom'>
		///      Array of parameters that are host application specific.
		/// </param>
		/// <seealso class='IDTExtensibility2' />
        public void OnBeginShutdown(ref System.Array custom)
        {
            CommandBarButton button = (CommandBarButton)applicationObject.CommandBars.FindControl(Type.Missing, Type.Missing, this.addinLib.GetString("OdfImportLabel"), Type.Missing);
            button.Delete(Type.Missing);
            button = (CommandBarButton)applicationObject.CommandBars.FindControl(Type.Missing, Type.Missing, this.addinLib.GetString("OdfExportLabel"), Type.Missing);
            button.Delete(Type.Missing);

        }

        int SetPPTXasDefault()
        {
            using (RegistryKey key = Registry.CurrentUser.OpenSubKey(OptionKey, true))
            {
                int ret = (int)key.GetValue(OptionValue, -1);
                key.SetValue(OptionValue, 0x21, RegistryValueKind.DWord);
                return ret;
            }
        }

        void RestoreDefault(int oldFormat)
        {
            // Delete the value
            using (RegistryKey key = Registry.CurrentUser.OpenSubKey(OptionKey, true))
            {
                if (oldFormat == -1)
                {
                    key.DeleteValue(OptionValue);
                }
                else
                {
                    key.SetValue(OptionValue, oldFormat);
                }
            }
        }

        //private object applicationObject;
        //private object addInInstance;

        private const string OptionKey = @"Software\Microsoft\Office\10.0\PowerPoint\Options";
        private const string OptionValue = "DefaultFormat";

        private PowerPoint.Application applicationObject;
        private OdfAddinLib addinLib;
        private CommandBarButton importButton, exportButton;



        #region IOdfConverter Members

        public void OdfToOox(string inputFile, string outputFile, bool showUserInterface)
        {
            this.addinLib.OdfToOox(inputFile, outputFile, showUserInterface);
        }
        public void OoxToOdf(string inputFile, string outputFile, bool showUserInterface)
        {
            this.addinLib.OoxToOdf(inputFile, outputFile, showUserInterface);
        }

        #endregion
    }
}