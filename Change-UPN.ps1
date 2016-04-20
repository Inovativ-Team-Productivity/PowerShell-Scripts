$users = get-aduser -SearchBase "OU=Users,DC=ad,DC=contoso,DC=com" -Filter * -Properties EmailAddress |
where {$_.EmailAddress -ne $null -AND $_.EmailAddress.toLower() -ne $_.UserPrincipalName.toLower()}
 
foreach ($user in $users) {
    $forest = Get-ADForest
    $email = $user.EmailAddress
    $username = $email.toLower().Split('@')[0]
    $userdomain = $email.toLower().Split('@')[1]
    if (-Not $($forest.UPNSuffixes).Contains($userdomain)) {
        $forest | Set-ADForest -UPNSuffixes @{Add="$userdomain"}
    }
    $user | Set-ADUser -UserPrincipalName "$username@$userdomain"
}
