#!/bin/bash
if [[ "$(echo "$@" | cut -f1 -d=)" = "Score" ]]
then   
    NOTE=$(echo "$@" | cut -f2 -d=)
    if [[ $NOTE =~ (^[0-9]([.][0-9]*)?$|^10$) ]]
        then
        echo -e "\n[$(tput setaf 3)INFO$(tput sgr 0)] ...Running Java linting for Score=$(tput setaf 6)$NOTE$(tput sgr 0)\n"
        cd ..
        mvn verify
        cd helper
        INSTRUCTION=$(sh getInstructions.sh)
        python -c "print(round($INSTRUCTION*(1-$NOTE/10)/8))" > maxAllowedViolation
        echo -e "\n[$(tput setaf 3)INFO$(tput sgr 0)]  maxAllowedViolation=$(cat maxAllowedViolation)\n\n"
        cd ..
        echo -e "[$(tput setaf 3)INFO$(tput sgr 0)]  mvn checkstyle:check -D checkstyle.maxAllowedViolations=$(cat helper/maxAllowedViolation) -D checkstyle.config.location=google_checks.xml -D checkstyle.violationSeverity=warning"
        mvn checkstyle:check -D checkstyle.maxAllowedViolations=$(cat helper/maxAllowedViolation) -D checkstyle.config.location=google_checks.xml -D checkstyle.violationSeverity=warning
    else 
        echo -e "[$(tput setaf 1)ERROR$(tput sgr 0)] Invalid value for parameter Score.  (must be float in [0.0,10.0])"    
    fi
else
    echo -e "[$(tput setaf 1)ERROR$(tput sgr 0)] Parameter Score= shouldn't be empty"
fi
