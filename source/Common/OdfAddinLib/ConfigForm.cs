﻿/*
 * Copyright (c) 2008, Clever Age
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Clever Age nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 */

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Globalization;
using System.Threading;
using Microsoft.Win32;
using System.Resources;

namespace OdfConverter.OdfConverterLib
{
    /// <summary>
    ///     Module ID:      Optional Dialog Box
    ///     Description:    Odf Converter 
    ///     Author:         Sateesh
    ///     Create Date:    2008-05-13
    /// </summary>
    public partial class ConfigForm : Form
    {
        private AbstractOdfAddin _addin;
        
        /// <summary>
        /// The name of the Registry value to store the check box state
        /// </summary>
        public const string FidelityValue = "fidelityValue";
        
        public ConfigForm(AbstractOdfAddin addin, ResourceManager manager)
        {
            InitializeComponent();

            this._addin = addin;

            try
            {
                // Change the title
                string newTitle = manager.GetString("OdfConverterTitle");
                if (!string.IsNullOrEmpty(newTitle))
                {
                    this.Text = newTitle;
                }

                string fidelityValue = Microsoft.Win32.Registry.GetValue(this._addin.RegistryKeyUser, ConfigForm.FidelityValue, "false") as string;

                if (fidelityValue == null)
                {
                    fidelityValue = "false";
                }

                chkbxIsErrorIgnored.Checked = fidelityValue.Equals("false", StringComparison.InvariantCultureIgnoreCase);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine(ex.ToString());
                MessageBox.Show(ex.Message);
            }
        }


        private void btnOK_Click(object sender, EventArgs e)
        {
            if (chkbxIsErrorIgnored.Checked)
            {
                Microsoft.Win32.Registry.SetValue(this._addin.RegistryKeyUser, ConfigForm.FidelityValue, "false");
            }
            else
            {
                Microsoft.Win32.Registry.SetValue(this._addin.RegistryKeyUser, ConfigForm.FidelityValue, "true");
            }
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}