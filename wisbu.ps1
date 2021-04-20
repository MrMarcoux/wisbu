Import-Module -Name ./BackupUtil -Verbose

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows installation setup backup utility'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter the path to which to save the backup to:'
$form.Controls.Add($label)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$envCheckBox = New-Object System.Windows.Forms.CheckBox
$envCheckBox.Location = New-Object System.Drawing.Point(10,65)
$envCheckBox.Size = New-Object System.Drawing.Size(20,20)
$envCheckBox.Checked = $True
$form.Controls.Add($envCheckBox)

$envLabel = New-Object System.Windows.Forms.Label
$envLabel.Location = New-Object System.Drawing.Point(28,67)
$envLabel.Size = New-Object System.Drawing.Size(200,40)
$envLabel.Text = 'Include environment variables'
$form.Controls.Add($envLabel)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Text = ("G:\Backup" + (Get-Date -Format "MM-dd-yyyy__HH-mm"))
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $options = @("startmenu")
    
    if ($envCheckBox.Checked) {
        $options = $options + "environment"
    }

    Backup-Util $textBox.Text $options
}