#!/bin/bash
if [[ "$(echo "$@" | cut -f1 -d=)" = "Score" ]]
then   
    NOTE=$(echo "$@" | cut -f2 -d=)
    if [[ $NOTE =~ (^[0-9]([.][0-9]*)?$|^10$) ]]
        then
        echo -e "\n[INFO] ...Running Java linting for Score=$NOTE\n"
        cd ..
        mvn verify
        cd JavaScoringLinter
        INSTRUCTION=$(sh getInstructions.sh)
        python -c "print(round($INSTRUCTION*(1-$NOTE/10)/8))" > maxAllowedViolation
        echo -e "\n[INFO]  maxAllowedViolation=$(cat maxAllowedViolation)\n\n"
        cd ..
        echo -e "[INFO]  mvn checkstyle:check -D checkstyle.maxAllowedViolations=$(cat JavaScoringLinter/maxAllowedViolation) -D checkstyle.config.location=google_checks.xml -D checkstyle.violationSeverity=warning"
        mvn checkstyle:check -D checkstyle.maxAllowedViolations=$(cat JavaScoringLinter/maxAllowedViolation) -D checkstyle.config.location=google_checks.xml -D checkstyle.violationSeverity=warning
    else 
        echo -e "[ERROR] Invalid value for parameter Score.  (must be float in [0.0,10.0])"    
    fi
else
    echo -e "[ERROR] Parameter Score= shouldn't be empty"
fi
