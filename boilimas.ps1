# Set user details
git config --global user.name "Name"
git config --global user.email "Email"

# Go to your repository
cd RepoPath

# Define the pattern for "DANLIMA". This should be adapted to fit the actual pattern you want.
$pattern = @(
    "11110", "10001", "10001", "10001", "11110", "00000", "00000",
    "01110", "10001", "11111", "10001", "10001", "00000", "00000",
    "10001", "11001", "10101", "10011", "10001", "00000", "00000",
    "10000", "10000", "10000", "10000", "11111", "00000", "00000",
    "01110", "00100", "00100", "00100", "01110", "00000", "00000",
    "10001", "11011", "10101", "10001", "10001", "00000", "00000",
    "01110", "10001", "11111", "10001", "10001", "00000", "00000"
)

# Calculate the start date
$start_date = [DateTime]::Today.AddDays(((1,[int][DayOfWeek]::Monday - [int][DateTime]::Today.DayOfWeek) % 7))

# Loop over each letter
for ($letter_index = 0; $letter_index -lt $pattern.Length / 7; $letter_index++) {
    # Loop over each line in the letter
    for ($line_index = 0; $line_index -lt 7; $line_index++) {
        # Loop over each day in the line
        $line = $pattern[$letter_index * 7 + $line_index]
        for ($char_index = 0; $char_index -lt $line.Length; $char_index++) {
            # If the character is 1, make a commit
            if ($line[$char_index] -eq "1") {
                # Calculate the date of the commit
                $date = $start_date.AddDays($line_index).AddWeeks($char_index)

                # Set environment variables for the commit
                $env:GIT_AUTHOR_DATE = $date.ToString("yyyy-MM-dd HH:mm:ss")
                $env:GIT_COMMITTER_DATE = $date.ToString("yyyy-MM-dd HH:mm:ss")
                $commit_message = "commit on $($date.ToString('yyyy-MM-dd'))"
                $env:GIT_COMMIT_MESSAGE = $commit_message

                # Create a file with the current date and commit it
                Set-Content -Path file.txt -Value $date
                git add .

                # Make the commit
                git commit -m $commit_message
            }
        }
    }

    # Add 2 weeks between each letter
    $start_date = $start_date.AddDays(14)
}

# Push to GitHub
git push
