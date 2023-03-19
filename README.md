#  Harnessing Electronic Health Records for Real World Evidence
This page provides the resources and tools mentioned from the entire available biomedical scientific literature, [Harnessing Electronic Health Records for Real World Evidence.](https://arxiv.org/abs/2211.16609)
## Table of Contents
- [Background and Flowchart](#BackgroundandFlowchart)
- [Method](#Method)
    - [Module one: Creating Meta-Data for Harmonization](#Moduleone)
      + [Concept Identification](#ConceptIden)
      + [Concept Matching](#ConceptMatching)
    - [Module two: Cohort Construction](#Moduletwo)
      + [Data Mart](#Datamart)
      + [Diease Corhort](#Diseasecorhort)
      + [Treatment Arms and Timing](#Treatment&arm)
    - [Module three: Variable Curation](#Modulethree)
      + [Endpoints](#Endpoints)
      + [Missing Data](#Missingdata)
    - [Module four: Validation and Robust Modelling](#Modulefour) 
      + [Validation and Tuning of Data Curation](#Validation) 
      + [Robust analysis for imperfect data](#Imperfect) 
      + [Robust adjustment for confounding](#Adconfound) 
      + [Creation of Digital Twins from RWD](#Digitaltwins) 
- [Contributing](#Contributing)
- [License](#License)
## Background and Flowchart<a name="BackgroundandFlowchart"></a>
In this study, we outline an integrated pipeline to improve the resolution of EHR data for precision medicine research, bridging the gap between technological innovation and application to clinical studies. We summarize the technologies and methods available for data curation and causal modelling that will enable researchers to perform robust analysis with high quality data from EHRs for RWE generation. Our pipeline has 4 modules: 1) creating meta-data for harmonization, 2) cohort construction, 3) variable curation, and 4) validation and robust modeling (Figure 1). The lists of methods and resources integrated into the pipeline are listed for each module of the pipeline, respectively. The pipeline contributes simultaneously to the creation of digital twins.

![The Integrated Data Curation pipeline designed to enable researchers to extract high quality data from electronic health records (EHRs) for RWE.](https://github.com/QingyiZengumn/Harnessing-electronic-health-records-for-real-world-evidence/blob/main/Flowchart.png)
<a name="myfootnote1">**Figure 1**</a>:The Integrated Data Curation pipeline designed to enable researchers to extract high quality data from electronic health records (EHRs) for RWE.



## Method <a name="Method"></a>

### Module one: Creating Meta-Data for Harmonization<a name="Moduleone"></a>
The first step in our pipeline is to perform data harmonization by mapping clinical variables of interest to relevant sources of data within EHRs. To make this mapping process more efficient and transparent, we propose an automated method using NLP for data harmonization. This approach can help streamline the process and improve accuracy in identifying the clinical relevant concepts.
#### Concept Identification <a name="ConceptIden"></a>
Identify the medical concepts associated with the clinical variables from the RCT documents using existing clinical NLP software.
<table>
    <thead>
        <tr>
            <th>Use</th>
            <th>Methods</th>
            <th>Links</th>
             <th>References</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=4>Identify medical concepts from RCT documents
</td>
            <td>Metamap</td>
            <td><a href="https://lhncbc.nlm.nih.gov/ii/tools/MetaMap.html">Tools: MetaMap</a></td>
            <td><a href="https://lhncbc.nlm.nih.gov/ii/information/Papers/metamap06.pdf">Mapping Text to the UMLS Metathesaurus</a></td>
        </tr>
        <tr>
            <td>HPO</td>
         <td><a href="https://hpo.jax.org/app/">The Human Phenotype Ontology</a></td>
            <td><a href="https://pubmed.ncbi.nlm.nih.gov/33264411/">
The Human Phenotype Ontology in 2021</a></td>
        </tr>
        <tr>
            <td>NILE</td>
            <td><a href="https://celehs.github.io/NILE.html">Narrative Information Linear Extraction (NILE)</a></td>
            <td><a href="https://arxiv.org/abs/1311.6063">
NILE: Fast Natural Language Processing for Electronic Health Records</a></td>
        </tr>
        <tr>
            <td>cTAKES</td>
            <td><a href="https://ctakes.apache.org/">Apache cTAKES</a></td>
            <td><a href="https://pubmed.ncbi.nlm.nih.gov/34042745/">
Entity Extraction for Clinical Notes, a Comparison Between MetaMap and Amazon Comprehend Medical</a></td>
        </tr>
    </tbody>
</table>

#### Concept Matching <a name="ConceptMatching"></a>
Match the identified medical concepts to both structured and unstructured EHR data elements.
<table>
    <thead>
        <tr>
            <th>Use</th>
            <th>Methods</th>
            <th>Links</th>
             <th>References</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=4>Grouping of structured EHR</td>
            <td>PheWAS catalog</td>
            <td><a href="https://phewascatalog.org/">Phenome Wide Association Studies</a></td>
            <td><a href="https://pubmed.ncbi.nlm.nih.gov/20335276/">PheWAS: demonstrating the feasibility of a phenome-wide scan to discover gene-disease associations</a></td>
        </tr>
        <tr>
            <td>CCS, CPT-4/HCPCS, ICD-9-PCS, ICD-10-PCS</td>
         <td> <a href="https://www.cms.gov/Medicare/Coding/ICD9ProviderDiagnosticCodes/codes">ICD-9-CM Diagnosis and Procedure Codes</a>,
              <a href="https://www.cms.gov/medicare/icd-10/2023-icd-10-pcs">2023 ICD-10-PCS</a>,
              <a href="https://www.cms.gov/search/cms?keys=CPT&sort=&searchpage">List of CPT/HCPCS Codes</a>,
              <a href="https://hcup-us.ahrq.gov/toolssoftware/ccs/ccs.jsp">CLINICAL CLASSIFICATIONS SOFTWARE (CCS) FOR ICD-9-CM
</a>, <a href="https://hcup-us.ahrq.gov/toolssoftware/ccs10/ccs10.jsp">CLINICAL CLASSIFICATIONS SOFTWARE (CCS) FOR ICD-10-PCS (BETA VERSION)
             </td>
              <td><a href="https://hcup-us.ahrq.gov/reports/natstats/his95/clinclas.htm">
Clinical Classifications for Health Policy Research: Version 2 : Software and User’s Guide. (U.S. Department of Health and Human Services, Public Health Service, Agency for Health Care Policy and Research</a></td>
        </tr>   
        <tr>
            <td>RxNorm</td>
            <td><a href="https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html">RxNorm Files</a></td>
            <td><a href="https://www.nlm.nih.gov/research/umls/rxnorm/RxNorm.pdf">
RxNorm: Prescription for Electronic Drug Information Exchange</a></td>
        </tr>
        <tr>
            <td>Lonic</td>
            <td><a href="https://loinc.org/downloads/">Download Lonic</a></td>
            <td><a href="https://pubmed.ncbi.nlm.nih.gov/12651816/">
LOINC, a universal standard for identifying laboratory observations: a 5-year update</a></td>
        </tr>
        <tr>
            <td rowspan=4>Expansion and selection of relevant features using knowledge source or cooccurrence
</td>
            <td>Export curation</td>
            <td><a href="https://www.nlm.nih.gov/research/umls/index.html">UMLS</a>, <a href="https://www.wikidata.org/wiki/Wikidata:Database_download">Wikidata</a> </td>
            <td><a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC308795/">The Unified Medical Language System (UMLS): integrating biomedical terminology, <a href="https://en.wikipedia.org/wiki/Freebase_(database)">Freebase (database)
</a></td>
        </tr>
        <tr>
            <td>Knowledge sources</td>
         <td> <a href="https://bio.nlplab.org/pdf/pyysalo13literature.pdf">Distributional Semantics Resources </a>, <a href="?">35-39</a></td>
              <td><a href="http://bio.nlplab.org/">Biomedical natural language processing Tools and resources</a></td>
        </tr>   
        <tr>
            <td>EHR data</td>
            <td><a href="https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html">27,40-44</a></td>
            <td><a href="https://www.nlm.nih.gov/research/umls/rxnorm/RxNorm.pdf">
RxNorm: Prescription for Electronic Drug Information Exchange</a></td>
        </tr>
    </tbody>
</table>



### Module two: Cohort Construction <a name="Moduletwo"></a>
The construction of the study cohort for RWE involves identifying the patients with the condition/disease of interest, their time window for the indication and whether they underwent the interventions in the RCT. EHR data contain a large amount of data of which a subset is relevant to the study.   To avoid involving unnecessary personal health identifiers into the data for analysist, we recommend a 3-phase cohort construction strategy that gradually extracts the minimally necessary data from the EHR, starting from an inclusive data mart to the disease cohort and then to the treatment arms. 


#### Data Mart<a name="Datamart"></a>
The data mart is designed to include all patients with any indication of the disease or condition of interest. To achieve the desired inclusiveness, researchers should summarize a broad list of EHR variables with high sensitivity and construct the data mart to capture patients with at least one occurrence of the listed variables.

<table>
    <thead>
        <tr>
            <th>Use</th>
            <th>Methods</th>
            <th>Links</th>
             <th>References</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>Filter patients with diagnosis codes relevant to disease of interest</td>
            <td>PheWAS catalog</td>
            <td><a href="https://phewascatalog.org/">Phenome Wide Association Studies</a></td>
            <td><a href="https://pubmed.ncbi.nlm.nih.gov/20335276/">PheWAS: demonstrating the feasibility of a phenome-wide scan to discover gene-disease associations</a></td>
        </tr>
           <td>HPO</td>
         <td><a href="https://hpo.jax.org/app/">The Human Phenotype Ontology</a></td>
            <td><a href="https://pubmed.ncbi.nlm.nih.gov/33264411/">
The Human Phenotype Ontology in 2021</a></td>       
    <tbody>
</table>    

#### Diease Corhort<a name="Diseasecorhort"></a>
After the data mart is created, the next step is to identify the disease cohort containing the subset of patients within the data mart who have the disease of interest.Commonly used phenotyping tools can be roughly classified as either rule-based or machine-learning based. Machine learning approaches can be further classified as either weakly supervised, semi-supervised, or supervised based on the availability of gold-standard labels for model training.

<table>
    <thead>
        <tr>
            <th>Use</th>
            <th>Methods</th>
            <th>Links</th>
             <th>References</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=11>Identify patients with disease of interest through phenotyping</td>
            <td>Unsupervised: anchor and learn, XPRESS53, APHRODITE, PheNorm, MAP and sureLDA; Semi-supervised: AFEP, SAFE, PSST, likelihood approach, and PheCAP
 </td>
            <td><a href="https://phewascatalog.org/">Phenome Wide Association Studies</a>,<a href="https://github.com/clinicalml/anchorExplorer
">Anchorexplorer</a>,<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5070523/
">Express</a>,<a href="https://github.com/OHDSI/Aphrodite">Aphrodite</a>,<a href="https://celehs.github.io/PheNorm/">PheNorm</a>, <a href="https://github.com/celehs/MAP">MAP</a>, <a href="https://github.com/celehs/sureLDA">sureLDA</a>, <a href="https://github.com/ModelOriented/SAFE">SAFE</a>, <a href="https://github.com/ModelOriented/SAFE">SAFE</a>,
            <a href="https://github.com/celehs/PheCAP">PheCAP </a></td>
<td><a href="https://pubmed.ncbi.nlm.nih.gov/33264411/">
The Human Phenotype Ontology in 2021</a></td>       
    <tbody>
</table>      
        
#### Treatment Arms and Timing <a name="Treatment&arm"></a>
With a given disease cohort, one may proceed to identify patients who received the relevant treatments, which are typically medications or procedures.
<table>
    <thead>
        <tr>
            <th>Use</th>
            <th>Methods</th>
            <th>Links</th>
             <th>References</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=1>Identify indication conditions before treatment
</td>
            <td>Phenotyping with temporal input
</td>
            <td><a href="https://github.com/hestiri/MSMR">MSMR</a>
            ,<a href="https://github.com/hestiri/TSPM
">TSPM</a>
            , <a href="https://github.com/hestiri/AgeMatters">AgeMatters</a>
 </td>
            <td><a href="https://pubmed.ncbi.nlm.nih.gov/33313899/">High-throughput phenotyping with temporal sequences.</a></td>
    <tbody>
</table>   
### Variable Curation <a name="Modulethree"></a>
#### Endpoints<a name="Endpoints"></a>
#### Missing Data<a name="Missingdata"></a>
### Validation and Robust Modelling<a name="Modulefour"></a>
#### Validation and Tuning of Data Curation<a name="Validation"></a>
#### Robust analysis for imperfect data<a name="Imperfect"></a>
#### Robust adjustment for confounding<a name="Adconfound"></a>
#### Creation of Digital Twins from RWD<a name="Digitaltwins"></a>
## Contributing <a name="Contributing"></a>
## License <a name="License"></a>

