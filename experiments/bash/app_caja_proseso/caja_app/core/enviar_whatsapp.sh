#!/bin/bash
# This script sends a WhatsApp message with a link to the generated HTML file.

# Path to the reporte_individual.sh script
REPORTE_IND_PATH="/path/to/your/reporte_individual.sh"

# Check if the script exists
if [[ -f "$REPORTE_IND_PATH" ]]; then
    # Call the script to generate the report
    HTML_FILE_PATH=$(bash "$REPORTE_IND_PATH")
    
    # Here, you would put the WhatsApp sending logic
    echo "Sending WhatsApp message with link to: $HTML_FILE_PATH"
else
    echo "Error: 'reporte_individual.sh' not found at the specified path."
fi
