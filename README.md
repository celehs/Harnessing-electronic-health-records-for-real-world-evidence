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
    - [Module three: Variable Extraction](#Modulethree)
      + [Extraction of Baseline Variables or Endpoints](#BaselineVariablesorEndpoints)
      + [Baseline Variables](#BaselineVariables)
      + [Baseline Endpoints](#BaselineEndpoints)
    - [Module four: Validation and Robust Modelling](#Modulefour) 
      + [Robust analysis and adjustment](#robust)

<a name="BackgroundandFlowchart"></a>
## Background and Flowchart
In this study, we outline an integrated pipeline to improve the resolution of EHR data that will enable researchers to perform robust analysis with high quality data from EHRs for RWE generation. Our pipeline has 4 modules: 1) creating meta-data for harmonization, 2) cohort construction, 3) variable curation, and 4) validation and robust modeling (Figure 1). The lists of methods and resources integrated into the pipeline are listed for each module of the pipeline, respectively. The pipeline contributes simultaneously to the creation of digital twins.

![The Integrated Data Curation pipeline designed to enable researchers to extract high quality data from electronic health records (EHRs) for RWE.](https://github.com/QingyiZengumn/Harnessing-electronic-health-records-for-real-world-evidence/blob/main/Flowchart.png)
<a name="myfootnote1">**Figure 1**</a>:The Integrated Data Curation pipeline designed to enable researchers to extract high quality data from electronic health records (EHRs) for RWE.


<a name="Method"></a>
## Method 
<a name="Moduleone"></a>
### Module one: Creating Meta-Data for Harmonization
The first step in our pipeline is to perform data harmonization by mapping clinical variables of interest to relevant sources of data within EHRs. To make this mapping process more efficient and transparent, we propose an automated method using NLP for data harmonization. This approach can help streamline the process and improve accuracy in identifying the clinical relevant concepts.
 <a name="ConceptIden"></a>
#### Concept Identification
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

<a name="ConceptMatching"></a>
#### Concept Matching
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
        </tr>
        <tr>
            <td>Knowledge sources</td>
         <td> <a href="https://bio.nlplab.org/pdf/pyysalo13literature.pdf">Distributional Semantics Resources </a>, <a href="https://pubmed.ncbi.nlm.nih.gov/"> PubMed </a>,  <a href="https://www.merckmanuals.com/">MerkMannual
</a>,  <a href="https://www.medscape.com/">Medscape</a></td> <td><a href="https://pubmed.ncbi.nlm.nih.gov/25160253/">Exploring the application of deep learning techniques on medical text corpora</a>,<a href="https://pubmed.ncbi.nlm.nih.gov/25160253/">Exploring the application of deep learning techniques on medical text corpora</a> </td>
        </tr>   
        <tr>
            <td>EHR data</td>
            <td><a href="https://www.data.va.gov/dataset/Corporate-Data-Warehouse-CDW-/ftpi-epf7?category=dataset&view_name=Corporate-Data-Warehouse-CDW-">VA Corporate Data Warehouse (CDW)</a>,<a href="https://www.massgeneralbrigham.org/en
">Mass General Brigham (MGB)</a> </td>
            <td><a href="https://www.medrxiv.org/content/10.1101/2021.03.13.21253486v1
">
Clinical Knowledge Extraction via Sparse Embedding Regression (KESER) with Multi-Center Large Scale Electronic Health Record Data. 
</a></td>
        </tr>
    </tbody>
</table>
             

<a name="Moduletwo"></a>
### Module two: Cohort Construction
The construction of the study cohort for RWE involves identifying the patients with the condition/disease of interest, their time window for the indication and whether they underwent the interventions in the RCT. EHR data contain a large amount of data of which a subset is relevant to the study.   To avoid involving unnecessary personal health identifiers into the data for analysist, we recommend a 3-phase cohort construction strategy that gradually extracts the minimally necessary data from the EHR, starting from an inclusive data mart to the disease cohort and then to the treatment arms. 

<a name="Datamart"></a>
#### Data Mart
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

<a name="Diseasecorhort"></a>
#### Diease Corhort
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
  <td>Unsupervised: anchor and learn, XPRESS53, APHRODITE, PheNorm, MAP and sureLDA</td>
  <td><a href="https://phewascatalog.org/">Phenome Wide Association Studies</a>, <a href="https://github.com/clinicalml/anchorExplorer
">Anchorexplorer</a>, <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5070523/
">Express</a>, <a href="https://github.com/OHDSI/Aphrodite">Aphrodite</a>, <a href="https://celehs.github.io/PheNorm/">PheNorm</a>, <a href="https://github.com/celehs/MAP">MAP</a>, <a href="https://github.com/celehs/sureLDA">sureLDA</a></td>
  <td><a href="https://pubmed.ncbi.nlm.nih.gov/27107443/">
    Electronic medical record phenotyping using the anchor and learn framework</a>, <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5070523/">
      Learning statistical models of phenotypes using noisy labeled training data</a>, <a href="https://pubmed.ncbi.nlm.nih.gov/28815104/">
        Electronic medical record phenotyping using the anchor and learn framework</a>, <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6251688/">
          Enabling phenotypic big data with PheNorm</a>,
        <a href="https://pubmed.ncbi.nlm.nih.gov/31613361">
          High-throughput multimodal automated phenotyping (MAP) with application to PheWAS
        </a>, <a href="https://pubmed.ncbi.nlm.nih.gov/32548637/">A multidisease automated phenotyping method for the electronic health record</a></td><tr>          
          <td>Semi-supervised: AFEP, SAFE, PSST, likelihood approach, and PheCAP</td>
          <td> <a href="https://github.com/ModelOriented/SAFE">SAFE</a>, <a href="https://github.com/celehs/PheCAP">PheCAP </a></td>       
          <td><a href="https://pubmed.ncbi.nlm.nih.gov/25929596/">
            Toward high-throughput phenotyping: unbiased automated feature extraction and selection from knowledge sources</a>, <a href="https://pubmed.ncbi.nlm.nih.gov/27632993
">
              Surrogate-assisted feature extraction for high-throughput phenotyping
            </a>, <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6371355/">
              Phenotyping through Semi-Supervised Tensor Factorization (PSST)
            </a>, <a href="https://pubmed.ncbi.nlm.nih.gov/31722396/">
              A maximum likelihood approach to electronic health record phenotyping using positive and unlabeled patients.
            </a>, <a href="https://pubmed.ncbi.nlm.nih.gov/31748751">
              High-throughput phenotyping with electronic medical record data using a common semi-supervised approach (PheCAP)</a></td>       
              <tbody>
              </table>      
            
<a name="Treatment&arm"></a>
#### Treatment Arms and Timing
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
 
<a name="Modulethree"></a>
### Module three: Variable Extraction
RCT emulation with EHR data generally requires three categories of data elements: 1) the endpoints measuring the treatment effect; 2) eligibility criteria to match the RCT population; 3) confounding factors to correct for treatment by indication biases inherent in real world data. In the following, we describe the classification and extraction of the first two types while addressing the confounding in Module 4.

<a name="BaselineVariablesorEndpoints"></a>
#### Extraction of Baseline Variables or Endpoints
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
            <td>Extraction of binary variables through phenotypings</td>
            <td>Same as Identify patients with disease of interest through phenotyping</td>
            <td>Same as Identify patients with disease of interest through phenotyping</td>
            <td>Same as Identify patients with disease of interest through phenotyping</td>
        <tr>
             <td>Extraction of numerical variables through NLP</td>
             <td>EXTEND (<a href="https://github.com/TianrunCai/EXTEND
">Code</a>, <a href="https://bmcmedinformdecismak.biomedcentral.com/articles/10.1186/s12911-019-0970-1">Ref</a>), NICE</td>
             <td><a href="https://github.com/TianrunCai/EXTEND
">EXTEND</a>, <a href="https://celehs.github.io/NILE.html">NILE</a> </td>
            <td><a href="https://bmcmedinformdecismak.biomedcentral.com/articles/10.1186/s12911-019-0970-1">EXTraction of EMR numerical data: an efficient and generalizable tool to EXTEND clinical research</a>,<a href="https://jamanetwork.com/journals/jamanetworkopen/fullarticle/2781685">Performance of a Machine Learning Algorithm Using Electronic Health Record Data to Identify and Estimate Survival in a Longitudinal Cohort of Patients With Lung Cancer</a></td>
    <tbody>
</table>   
 
 <a name="BaselineVariables"></a>
#### Extraction of Baseline Variables
        
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
            <td>Extraction of radiological characteristics through medical AI</td>
            <td>Same as Identify patients with disease of interest through phenotyping</td>
            <td>organs, blood vessel, neural system, <a href="https://github.com/iMED-Lab/CS-Net">CS-Net</a>, <a href="https://github.com/wentaozhu/D">DeepLung</a>, nodule detection, cancer staging, fractional flow, reserve</td>
            <td><a href="https://www.sciencedirect.com/science/article/abs/pii/S1361841518302524?via%3Dihub">Abdominal multi-organ segmentation with organ-attention networks and statistical fusion</a>, <a href="https://www.sciencedirect.com/science/article/abs/pii/S0169260717313421?via%3Dihub">Blood vessel segmentation algorithms - Review of methods, datasets and evaluation metrics</a>, <a href="https://www.springerprofessional.de/en/segmentation-of-corneal-nerves-using-a-u-net-based-convolutional/16122514">Segmentation of Corneal Nerves Using a U-Net-Based Convolutional Neural Network</a>, <a href="https://www.springerprofessional.de/cs-net-channel-and-spatial-attention-network-for-curvilinear-str/17254998">Channel and Spatial Attention Network for Curvilinear Structure Segmentation</a>,  <a href="https://www.sciencedirect.com/science/article/abs/pii/S0031320318302711">Automated pulmonary nodule detection in CT images using deep convolutional neural networks</a>,  <a href="https://arxiv.org/pdf/1801.09555.pdfeepLung
">DeepLung: Deep 3D Dual Path Nets for Automated Pulmonary Nodule Detection and Classification</a>, <a href="https://www.ahajournals.org/doi/full/10.1161/CIRCIMAGING.117.007217">Diagnostic accuracy of a deep learning approach to calculate FFR from coronary CT angiography</a>, <a href="https://academic.oup.com/ehjcimaging/article/21/4/437/5522163?login=false">Diagnostic accuracy of 3D deep-learning-based fully automated estimation of patient-level minimum fractional flow reserve from coronary computed tomography angiography</a></td>
            
            
            
         <tr>    
    <tbody>
</table>   
        
<a name="BaselineEndpoints"></a>        
#### Extraction of Baseline Endpoints
        
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
            <td rowspan=3>Extraction of event time through incidence phenotyping</td>
            <td>Unsupervised</td>
            <td>Unsupervised: <a href="https://github.com/chl8856/AC_TPC">AC_TPC</a></td>
             <td><a href="https://ieeexplore.ieee.org/document/6346556/metrics#metrics">Disease progression modeling using Hidden Markov Models</a>, <a href="https://proceedings.mlr.press/v119/lee20h.html">Temporal Phenotyping using Deep Predictive Clustering of Disease Progression</a></td>
         <tr>
            <td>Semi-supervised</td>
            <td>Semi-supervised: <a href="https://github.com/celehs/SAMGEP">SAMGEP</a></td>
            <td> <a href="https://www.medrxiv.org/content/10.1101/2021.03.07.21253096v1
">Samgep: A novel method for prediction of phenotype event times using the electronic health record</a>, <a href="https://link.springer.com/article/10.1007/s10985-022-09557-5
">Semi-supervised Approach to Event Time Annotation Using Longitudinal Electronic Health Records</a></td> 
          <tr>
             <td>Supervised</td>
             <td>Supervised</td>   
             <td> <a href="https://ascopubs.org/doi/10.1200/CCI.17.00163?url_ver=Z39.88-2003&rfr_id=ori:rid:crossref.org&rfr_dat=cr_pub%20%200pubmed">Determining the Time of Cancer Recurrence Using Claims or Electronic Medical Record Data</a>, <a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4732933/
">Detecting Lung and Colorectal Cancer Recurrence Using Structured Clinical/Administrative Data to Enable Outcomes Research and Population Health Management</a></td>
        <tr>
    <tbody>
</table>   
        
<a name="Modulefour"></a>        
### Module four: Validation and Robust Modelling
Confounding factors, variables that affect both the treatment assignment and outcome, must be properly adjusted. To minimize the bias, the pipeline should include 1) validation for optimizing the medical informatics tools in Modules 2 and 3 ; 2) analyses robust to remaining data error; 3) comprehensive confounding adjustment.

<a name="robust"></a>
#### Robust analysis and adjustment
        
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
            <td>Efficient and robust estimation of treatment effect with partially annotated noisy data</td>
            <td>SMMAL</td>
            <td></td>
            <td><a href="https://arxiv.org/abs/2110.12336">Efficient and Robust Semi-supervised Estimation of ATE with Partially Annotated Treatment and Response</a></td>
        <tr>
    <tbody>
</table>   
        
