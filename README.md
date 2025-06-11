# NSF_Terminations
Data on NSF's recently terminated awards, extending NSF's own CSV file at https://www.nsf.gov/updates-on-priorities#termination-list .

In May 2025 NSF released a data set listing the agency's terminations of awards to align with the strategic priorities of
the incoming administration. The data set included only the following columns:

- Award ID
- Directorate
- Recipient
- Title
- Obligated

This repository includes my code for retrieving additional data from NSF's website and repackaging it into a new dataset that includes:

- Award ID
- Directorate
- NSF Unit
- Award Instrument
- Recipient
- Title
- Start Date
- End Date (Note: Always 'estimated')
- Last Amendment Date
- Total Intended Award Amount
- Obligated (Note: Does not capture the FY in which the funds were obligated; total only)
- Principal Investigator Name (Note: Does not capture Co-PIs, Former PIs, or Former Co-PIs)
- Principal Investigator Email
- A link to the award record on NSF's server
- Abstract
- Whether the online award page includes a Project Outcomes Report (Note: Does not include report text)
- Obligations 2025, 2024, 2023 ... 2013 (As separate columns; these are obligations by Fiscal Year; sum to 'Obligated')

## Requirements
Code is run on a MacOS and requires zsh as the shell. Requires the original NSF file in the main directory.

- Download the NSF file
- Run 'retrieve.sh'; note that it retrieves each award individually and hits the NSF server to do so, with a delay of 10 seconds between each ping to avoid overtaxing their server
- Run 'preprocess.sh' in the 'raw' directory
- Run 'repackage.sh' in the main directory

Retrieve need only be run once, and will automatically skip any file that it has already retrieved. The arguments to retrieve.sh are the NSF file name and the total number of awards that should be available when it is complete (including those it skips). You can increase this on successive runs to retrieve more records until you have them all.

Preprocess converts the html files to txt; it will also skip any that have been done before when it does this. After converting any files that need it, it will perform two other passes to remove encoding characters. It does this on all the files (it is fast and harmless to do this on the same file twice).

Repackage creates a new CSV file with the columns listed above.
