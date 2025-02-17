Connect-MgGraph -Scopes "Group.ReadWrite.All"
 
# 读取CSV文件
$csvPath = "C:\Users\lu\Desktop\groups.csv"
$groups = Import-Csv -Path $csvPath
 
# 创建安全组并添加描述、所有者和成员
foreach ($group in $groups) {
    # 创建组
    $newGroup = New-MgGroup -DisplayName $group.GroupName -SecurityEnabled:$true -MailEnabled:$false -MailNickname $group.GroupName -Description $group.Description
   
    # 添加所有者
    $owners = $group.Owner -split ";"
    foreach ($owner in $owners) {
        $ownerId = (Get-MgUser -Filter "userPrincipalName eq '$owner'").Id
        $params = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$ownerId"
        }
        New-MgGroupOwnerByRef -GroupId $newGroup.Id -BodyParameter $params
    }
 
    # 添加成员
    $members = $group.Members -split ";"
    foreach ($member in $members) {
        $memberId = (Get-MgUser -Filter "userPrincipalName eq '$member'").Id
        $params = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$memberId"
        }
        New-MgGroupMemberByRef -GroupId $newGroup.Id -BodyParameter $params
    }
}