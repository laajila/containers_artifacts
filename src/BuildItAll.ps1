<# 
   Very simple build script to build it all. 
   Little error checking - should be checking script path instead of current location.
   Builds locally. Add tagging to also push to registry if needed.
#>
$location = Get-Location;

if($location.Path.EndsWith("src")){
    Write-Information "Building it all..."
    Push-Location poi;
    docker build -f Dockerfile -t "tripinsights/poi:1.0" .
    Pop-Location;
    Push-Location trips;
    docker build -f Dockerfile -t "tripinsights/trips:1.0" .
    Pop-Location;
    Push-Location tripviewer;
    docker build -f Dockerfile -t "tripinsights/tripviewer:1.0" .
    Pop-Location;
    Push-Location user-java;
    docker build -f Dockerfile -t "tripinsights/user-java:1.0" .
    Pop-Location;
    Push-Location userprofile;
    docker build -f Dockerfile -t "tripinsights/userprofile:1.0" .
    Pop-Location;
} else {
    Write-error "Failed - invalid execution path"
    exit 1;
}
