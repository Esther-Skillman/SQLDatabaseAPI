# COMP2001-Assessment-2
Version control for CW2 that contains
- API CW2Database written in C# and ASP.NET that launches a swagger UI composed of checking the database connection and CRUD operations 
- CW2SQLQuery.sql that implemented the database I use as an API endpoint
- This ReadMe file outlining the main purposes of the API

The main files that are of importance in my API are as follows:
- CW2DatabaseController.cs: All the definitions for my CRUD operations
- Services/AuthenticatorService.cs: The VerifyUserAdmin() method
- CW2Database.cs: Model definitions for the SQL database


## CRUD operation code examples: 

### CREATE
```
// POST: api/CreateProfile
        [HttpPost("ProfileService/CreateProfile")]
        public async Task<ActionResult<UserData>> CreateProfile(UserVerificationRequest createProfile)
        {
            try
            {
                // Extract user details from the verification request
                var username = createProfile.userName;
                var email = createProfile.email;
                var password = createProfile.password;

                // Call the InsertUser stored procedure to create the user and associated data
                await _dbContext.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC CW2.InsertUser 
                    @Username = {username},
                    @Email = {email},
                    @Password = {password}
                ");

                // Retrieve the created profile from the UserData table
                var createdProfile = await _dbContext.UserData.FindAsync(email);

                // Log the successful creation of the profile
                _logger.LogInformation($"Created profile for user: {email}");

                return CreatedAtAction(nameof(GetProfiles), new { email }, createdProfile);
            }
            catch (Exception ex)
            {
                // Log any exception that occurs during the process
                _logger.LogError($"Error creating profile: {ex.Message}");
                return StatusCode(500, "Internal server error");
            }
        }
```
### READ
```
// GET: api/ProfileService/ReadUsers
        [HttpGet("ProfileService/ReadUsers")]
        public IEnumerable<UserData> GetProfiles()
        {
            try
            {
                // Retrieve all profiles from the database
                var profiles = _dbContext.UserData.ToList();

                // Log the count of profiles retrieved
                _logger.LogInformation($"Retrieved {profiles.Count} profiles from the database.");

                return profiles;
            }
            catch (Exception ex)
            {
                // Log the exception
                _logger.LogError($"Error retrieving profiles from the database: {ex.Message}");
                throw; // Rethrow the exception or handle it as needed
            }
        }
```
### UPDATE
```
 // PUT: api/ProfileService/UpdateUserData/{email}/{password}
        [HttpPut("ProfileService/UpdateUserData/{Email}/{Password}")]
        public async Task<IActionResult> UpdateProfile(string Email, string Password, updateUserData updateProfile)
        {
            try
            {
                var newEmail = updateProfile.NewEmail; 
                var newUsername = updateProfile.NewUsername; 
                var newPassword = updateProfile.NewPassword; 
                var AboutMe = updateProfile.AboutMe;
                var MemberLocation = updateProfile.MemberLocation;
                var Units = updateProfile.Units;
                var ActivityTimePreference = updateProfile.ActivityTimePreference;
                var userHeight = updateProfile.userHeight;
                var userWeight = updateProfile.userWeight;
                var Birthday = updateProfile.Birthday;
                var MarketingLanguage = updateProfile.MarketingLanguage;

                // Call the UpdateUser stored procedure to update the user's data
                await _dbContext.Database.ExecuteSqlInterpolatedAsync($@"
            EXEC CW2.UpdateUser 
                @Email = {Email},
                @Password = {Password},
                @newEmail = {newEmail},
                @newUsername = {newUsername},
                @newPassword = {newPassword},
                @newAboutMe = {AboutMe},
                @newMemberLocation = {MemberLocation},
                @newUnits = {Units},
                @newActivityTimePreference = {ActivityTimePreference},
                @newUserWeight = {userWeight},
                @newUserHeight = {userHeight},
                @newBirthday = {Birthday},
                @newMarketingLanguage = {MarketingLanguage}
            ");

                // Retrieve the updated profile from the UserData table
                var updatedProfile = await _dbContext.UserData.FindAsync(newEmail);

                // Log the successful update of the profile
                _logger.LogInformation($"Updated profile for user: {newEmail}");

                return CreatedAtAction(nameof(GetProfiles), new { newEmail }, updatedProfile);
            }
            catch (Exception ex)
            {
                // Log any exception that occurs during the process
                _logger.LogError($"Error updating profile: {ex.Message}");
                return StatusCode(500, "Internal server error");
            }
        }
```
### DELETE
```

        // DELETE: api/ProfileService/{id}
        [HttpDelete("ProfileService/DeleteUser/{AdminUsername}/{AdminEmail}/{AdminPassword}")]
        public async Task<IActionResult> DeleteProfile(string AdminUsername, string AdminEmail, string AdminPassword, [FromBody] string userEmailToDelete)
        {
            // Check if the user is an admin using the VerifyUserAdmin method
            var isAdmin = await _authenticatorService.VerifyUserAdmin(new UserVerificationRequest
            {
                userName = AdminUsername,
                email = AdminEmail,
                password = AdminPassword
            });

            if (!isAdmin)
            {
                return BadRequest("Admin authentication failed.");
            }

            try
            {
                // Execute the DeleteUser stored procedure
                await _dbContext.Database.ExecuteSqlInterpolatedAsync($@"
            EXEC CW2.DeleteUser 
                @Email = {userEmailToDelete}
        ");

                return Ok($"{userEmailToDelete} was successfully archived."); // User deleted successfully
            }
            catch (Exception ex)
            {
                // Log any exception that occurs during the process
                _logger.LogError($"Error deleting user: {ex.Message}");
                return StatusCode(500, "Internal server error");
            }
        }
```
## Data models
```

    public class User
    {
        [Key]
        [Column("UserNo")]
        public int UserNo { get; set; }

        [Column("userStatus")]
        public string UserStatus { get; set; }

        [Column("Username")]
        public string Username { get; set; }

        [Column("Email")]
        public string Email { get; set; }

        [Column("userPassword")]
        public string UserPassword { get; set; }
    }

    public class UserVerificationRequest
    {
        public string userName { get; set; }

        public string email { get; set; }

        public string password { get; set; }
    }

    public class UserData
    {
        [Key]
        [MaxLength(320)]
        [Required]
        public string Email { get; set; }

        [MaxLength(720)]
        public string AboutMe { get; set; }

        [MaxLength(int.MaxValue)]
        [Column(TypeName = "VARCHAR(MAX)")]
        public string MemberLocation { get; set; } = "Plymouth, Devon, England";

        [MaxLength(255)]
        public string Units { get; set; } = "Metric";

        [MaxLength(255)]
        public string ActivityTimePreference { get; set; } = "Pace";

        [Column(TypeName = "DECIMAL(5, 1)")]
        public decimal? userHeight { get; set; }

        public int? userWeight { get; set; }

        public DateTime? Birthday { get; set; }

        [MaxLength(255)]
        public string MarketingLanguage { get; set; } = "English(UK)";

    }
    public class FavouriteActivity
    {
        [Key]
        [Column("UserNo")]
        public int UserNo { get; set; }

        [Key]
        [Column("Activities")]
        public string Activities { get; set; }

        [Column("FavouriteActivities")]
        public bool FavouriteActivities { get; set; }
    }

    // This is a class used within the UpdateProfile method 
    public class updateUserData
    {
        public string NewEmail { get; set; }
        public string NewUsername { get; set; }
        public string NewPassword { get; set; }

        [MaxLength(720)]
        public string AboutMe { get; set; }

        [MaxLength(int.MaxValue)]
        [Column(TypeName = "VARCHAR(MAX)")]
        public string MemberLocation { get; set; } = "Plymouth, Devon, England";

        [MaxLength(255)]
        public string Units { get; set; } = "Metric";

        [MaxLength(255)]
        public string ActivityTimePreference { get; set; } = "Pace";

        [Column(TypeName = "DECIMAL(5, 1)")]
        public decimal? userHeight { get; set; }

        public int? userWeight { get; set; }

        public DateTime? Birthday { get; set; }

        [MaxLength(255)]
        public string MarketingLanguage { get; set; } = "English(UK)";
    }
}
```
