# Example file from www.debontonline.com 
# Setup Microsoft 365 environment https://developer.microsoft.com/en-us/microsoft-365/dev-program
# Microsoft graph api documentation: https://docs.microsoft.com/en-us/graph/api/overview?view=graph-rest-1.0&preserve-view=true

# Minimum Required API permission for execution
# Policy.Read.All
# Policy.ReadWrite.ApplicationConfiguration
# Application.ReadWrite.All

# Connection information for Graph API connection - Certificate Based
$clientID = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" #  App Id MS Graph API Connector SPN
$TenantName = "<<tenantname>>.onmicrosoft.com" # Example debontonlinedev.onmicrosoft.com
$TenantID = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" # Tenant ID 
$CertificatePath = "Cert:\LocalMachine\my\xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # Add the Certificate Path Including Thumbprint here e.g. cert:\currentuser\my\6C1EE1A11F57F2495B57A567211220E0ADD72DC1 >#
##Import Certificate
$Certificate = Get-Item $certificatePath
##Request Token
$TokenResponse = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -ClientCertificate $Certificate
$TokenAccess = $TokenResponse.accesstoken



# Example 1: Create TokenLifeTimePolicy 
$CreateTokenPolicyBody  =  @{
	definition = @(
		'{\"TokenLifetimePolicy\":{\"Version\":1,\"AccessTokenLifetime\":\"02:00:00\"}}' ## AccessTokenLife hh:mm:ss (02:00:00 is two hours)
	)
	displayName = "AAD_Policy_TokenLifeTime_2_hours"
	isOrganizationDefault = $false
}
$CreateTokenPolicyUrl = "https://graph.microsoft.com/v1.0/policies/tokenLifetimePolicies"
$CreateTokenPolicy = Invoke-RestMethod -Uri $CreateTokenPolicyUrl -Headers @{Authorization = "Bearer $($TokenAccess)" }  -Method POST -Body $($CreateTokenPolicyBody | convertto-json).Replace('\\\','\') -ContentType "application/json"



# Example 2: Get TokenLifeTimePolicy
$GetTokenPolicyId ="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" # Id TokenLifeTimePolicy
$GetTokenPolicyUrl = "https://graph.microsoft.com/v1.0/policies/tokenLifetimePolicies/$GetTokenPolicyId"
$GetTokenPolicy = Invoke-RestMethod -Uri $GetTokenPolicyUrl -Headers @{Authorization = "Bearer $($TokenAccess)" }  -Method GET



# Example 3: Assign Tokenpolicy to Enterprise Application
$LinkTokenPolicyId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" # Id TokenLifeTimePolicy
$AppObjectId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" # ObjectId Application Registration
$LinkTokenPolicyBody  = @{
	"@odata.id" = "https://graph.microsoft.com/v1.0/policies/tokenLifetimePolicies/$LinkTokenPolicyId"
}
$LinkTokenPolicyUrl = "https://graph.microsoft.com/v1.0/applications/$AppObjectId/tokenLifetimePolicies/`$ref"
$LinkTokenPolicy = Invoke-RestMethod -Uri $LinkTokenPolicyUrl -Headers @{Authorization = "Bearer $($TokenAccess)" }  -Method POST -Body $($LinkTokenPolicyBody | convertto-json) -ContentType "application/json"



# Example 4: Retrieve TokenPolicy from Enterprise Application
$GetTokenPolicyId ="xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
$AppObjectId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" #ObjectId Application Registration
$GetTokenPolicyUrl = "https://graph.microsoft.com/v1.0/applications/$AppObjectId/tokenLifetimePolicies/$DeleteTokenPolicyId/`$ref"
$GetTokenPolicy = Invoke-RestMethod -Uri $DeleteTokenPolicyUrl -Headers @{Authorization = "Bearer $($TokenAccess)" }  -Method GET



# Example 5: UnAssign TokenPolicy from Enterprise Application
$DeleteTokenPolicyId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
$AppObjectId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" #ObjectId Application Registration
$DeleteTokenPolicyUrl = "https://graph.microsoft.com/v1.0/applications/$AppObjectId/tokenLifetimePolicies/$DeleteTokenPolicyId/`$ref"
$LinkTokenPolicy = Invoke-RestMethod -Uri $DeleteTokenPolicyUrl -Headers @{Authorization = "Bearer $($TokenAccess)" }  -Method DELETE 



# Example 6: Retrieve TokenPolicy from Enterpriset Application
$AppObjectId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" #ObjectId Application Registration
$GetTokenPolicyUrl = "https://graph.microsoft.com/v1.0/applications/$AppObjectId/tokenLifetimePolicies"
$Data1 = Invoke-RestMethod -Uri $GetTokenPolicyUrl -Headers @{Authorization = "Bearer $($TokenAccess)" }  -Method GET
$Result1 = ($Data1 | select-object Value).Value
$GetTokenPolicy = $Result1


# Example 7: Delete TokenLifeTimePolicy
$DeleteTokenPolicyId = "80936c72-9f3b-454c-ad9b-915b30136e6d"  # Id TokenLifeTimePolicy
$DeleteTokenPolicyUrl = "https://graph.microsoft.com/v1.0/policies/tokenLifetimePolicies/$DeleteTokenPolicyId"
$DeleteTokenPolicy = Invoke-RestMethod -Uri $DeleteTokenPolicyUrl -Headers @{Authorization = "Bearer $($TokenAccess)" }  -Method DELETE 
