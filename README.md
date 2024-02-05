
# Scoring scripts

OPSWAT Metadefender Core from version 5.8.0 supports overriding the final verdict of a scan based on a custom "Post Action" script. By utilizing this ability with a simple bash or PowerShell script it is possible to assign different weights for the AV engines to influence the final verdict.

Let us take the following example:

* we have 5 engines enabled: AhnLab, Bitdefender, ClamAV, ESET and K7
* we set the weights
	* AhnLab: 1
	* Bitdefender: 2
	* ClamAV: 3
	* ESET: 1
	* K7: 1
* we set the final threshold to 5

**(Disclaimer: this is just an example, we don’t intentionally compare engine’s qualities and say that ClamAV is better than the others.)**

When a scan is finished, the weights of those engines which reported the file as infected will be summed up. If the summed up weights are more or equal to the threshold, the final verdict will be infected. In the example above if Bitdefender and ClamAV finds the sample file infected, it is enough to set the final verdict to infected.

Please note that the "Post Action" script can only set the final verdict to infected and NOT clean. This means if you want to fully rely on scoring for the AV engine results, you have to set the infected AND suspicious AV thresholds to at least the number of your AV engines in your workflow under Metascan tab.

**This way the scoring script is fully responsible for the final verdict.**

There are 2 scripts provided in this folder:

* scoring.sh - Linux
* scoring.ps1 - Windows

These scripts do not rely on any external dependencies, they should work as it is in any environment currently supported by OPSWAT Metadefender Core.

If an engine cannot be found, but the weight is configured, the script considers this as an error and as a safe fallback it marks the final verdict as infected.

## scoring.sh
* Copy the script to any location which is accessible by the "metascan" user. Make sure the script is executable by

    chmod +x scoring.sh

* Edit the first couple lines of the script to set the weights and the threshold.
* Open Metadefender Core settings and under "Inventory" add a new "Post Action".
* Name can be arbitrary, Type should be "Sub-process" and the action shall only contain the path of the script e.g.:

    /home/ubuntu/scoring.sh

## scoring.ps1
* Copy the script to any location on the machine.
* Edit the first couple lines of the script to set the weights and the threshold.
* Open Metadefender Core settings and under "Inventory" add a new "Post Action".
* Name can be arbitrary, Type should be "Sub-process" and the action shall start with "PowerShell -File " and after that path of the script e.g.:

    PowerShell -File C:\Users\Administrator\scoring.ps1

## Activating the script
To activate the script:

* Open the settings of your workflow under "Workflow Management" and navigate to "Post Action" tab.
* Select the action and "Enable post action to block file".
* Set the return value to 1.

After activating the script, scoring should work as intended.

## Performance drawback
On an average machine with 8 CPUs and 16 GB or RAM the scan time will increase for each scan with ~100 ms on Linux and ~250 ms on Windows regardless of the input file size.
