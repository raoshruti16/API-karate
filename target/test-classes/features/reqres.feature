Feature: Test the reqres api
 Background:
 	Given def Base = 'https://reqres.in/api/users'

	Scenario: 01 Test the GET listUsers
		* url Base + '?page=2'
		When method GET
		And status 200
		Then def len1 = response.data.length
		Given url Base
		When method GET
		And status 200
		Then def len2 = response.data.length
		Then assert len1+len2 == 12
		Then assert len1+len2 == response.total

	
	Scenario Outline: 02 Test update user
		Given url Base + '/' + <id>
		When request { "name":"Shruti", "job":"Engineer" } 
		When method put
		Then status 200
		And match response contains { "name":"Shruti", "job":"Engineer" }
		And print "Updated at " + response.updatedAt
		
		Examples:
		|id	|
		|3	|
		|9	|
		
	Scenario Outline: 03 Test create user
		Given url Base 
		When request { "name": <name>, "job": <job>} 
		When method post
		Then status 201
		And match response contains { "name":<name>, "job":<job>}
		And print "Created at " + response.createdAt
		And print "id of new user is " + response.id
		
		Examples:
		|name 	|job				|
		|Shruti	|Software Engineer	|
		|Shreya	| Student			|
		
		
	Scenario Outline: 04 Test delete user
		Given url Base + <id>
		When method delete
		Then status 204
		Then match response == ''
		
		Examples:
		|id	|
		|4	|
		|10	|	
		
	Scenario Outline: 05 Test the single user details
		#PAGE 1
		Given url Base
		And method GET
		Then status 200
		Then def record = response.data
		Then match record contains deep [{first_name:<namepg1>}] 
		Then def id = get[0] response.data[?(@.first_name=="<namepg1>")].id
		Then def email = get[0] response.data[?(@.first_name=="<namepg1>")].email
		Then def last_name = get[0] response.data[?(@.first_name=="<namepg1>")].last_name
		Then def avatar = get[0] response.data[?(@.first_name=="<namepg1>")].avatar
		Then print id + " " + email + " " + last_name + " " + avatar
	
	
		#PAGE 2
		Given url Base + '?page=2'
		And method GET
		Then status 200
		Then def record = response.data
		Then match record contains deep [{first_name:<namepg2>}]
		Then def id = get[0] response.data[?(@.first_name=="<namepg2>")].id
		Then def email = get[0] response.data[?(@.first_name=="<namepg2>")].email
		Then def last_name = get[0] response.data[?(@.first_name=="<namepg2>")].last_name
		Then def avatar = get[0] response.data[?(@.first_name=="<namepg2>")].avatar
		Then print id + " " + email + " " + last_name + " " + avatar
		
		
	    Examples:
		|namepg2|namepg1|
		|Michael|Eve	|
		|Tobias	|Tracey |
		
		
		
		Scenario Outline: 06 Test user details
		Given url Base
		And method get
		Then status 200
		Then def record1 = response.data
		Given url Base + '?page=2'
		And method get
		Then status 200
		Then def record2 = response.data
		Then def check =
		"""
			function(arg){
				for(i=0;i<arg.length;i++){
					if((arg[i].first_name)=="<name>")
					{
						return(arg[i])
					}
					
				}
			}
		"""
		Then def returned1 = call check record1 
		Then def returned2 = call check record2
		And print returned1 + " " + returned2
		
		Examples:
		|name	|
		|Eve	|
		|Michael|
		|Tobias	|
		|Tracey	|

		