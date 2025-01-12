// Declare variables for getting the xml file for the XSL transformation (folio_xml) and to load the image in IIIF on the page in question (number).
let tei = document.getElementById("folio");
let tei_xml = tei.innerHTML;
let extension = ".xml";
let folio_xml = tei_xml.concat(extension);
let page = document.getElementById("page");
let pageN = page.innerHTML;
let number = Number(pageN);

// Loading the IIIF manifest
var mirador = Mirador.viewer({
  "id": "my-mirador",
  "manifests": {
    "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json": {
      provider: "Bodleian Library, University of Oxford"
    }
  },
  "window": {
    allowClose: false,
    allowWindowSideBar: true,
    allowTopMenuButton: false,
    allowMaximize: false,
    hideWindowTitle: true,
    panels: {
      info: false,
      attribution: false,
      canvas: true,
      annotations: false,
      search: false,
      layers: false,
    }
  },
  "workspaceControlPanel": {
    enabled: false,
  },
  "windows": [
    {
      loadedManifest: "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json",
      canvasIndex: number,
      thumbnailNavigationPosition: 'off'
    }
  ]
});


// function to transform the text encoded in TEI with the xsl stylesheet "Frankenstein_text.xsl", this will apply the templates and output the text in the html <div id="text">
function documentLoader() {

    Promise.all([
      fetch(folio_xml).then(response => response.text()),
      fetch("Frankenstein_text.xsl").then(response => response.text())
    ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("text");
      criticalElement.innerHTML = ''; // Clear existing content
      criticalElement.appendChild(resultDocument);
    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
  }
  
// function to transform the metadate encoded in teiHeader with the xsl stylesheet "Frankenstein_meta.xsl", this will apply the templates and output the text in the html <div id="stats">
  function statsLoader() {

    Promise.all([
      fetch(folio_xml).then(response => response.text()),
      fetch("Frankenstein_meta.xsl").then(response => response.text())
    ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("stats");
      criticalElement.innerHTML = ''; // Clear existing content
      criticalElement.appendChild(resultDocument);
    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
  }

  documentLoader();
  statsLoader();
  function selectHand(event) {
    var visible_mary = document.getElementsByClassName('#MWS');
    var visible_percy = document.getElementsByClassName('#PBS');
    var MaryArray = Array.from(visible_mary);
    var PercyArray = Array.from(visible_percy);
      if (event.target.value == 'both') {
        MaryArray.forEach((el) => {
          el.style.fontWeight = 'normal';
          el.style.color = 'black'; 
        });
        PercyArray.forEach((el) => {
          el.style.fontWeight = 'normal';
          el.style.color = 'black'; 
        });
      } else if (event.target.value == 'Mary') {
        MaryArray.forEach((el) => {
          el.style.fontWeight = 'bold';
          el.style.color = 'rgb(162, 13, 13)';
        });
        PercyArray.forEach((el) => {
          el.style.fontWeight = 'normal';
          el.style.color = 'black'; 
        });
      } else if (event.target.value == 'Percy'){
        MaryArray.forEach((el) => {
          el.style.fontWeight = 'normal';
          el.style.color = 'black'; 
        });
        PercyArray.forEach((el) => {
          el.style.fontWeight = 'bold';
          el.style.color = 'rgb(162, 13, 13)';
        }); 
      }
  }


// write another function that will toggle the display of the deletions by clicking on a button

function toggleDeletions(){
  var allDeletions = document.getElementsByTagName("del");
  
  for (var i = 0; i < allDeletions.length; i++) {
    if (allDeletions[i].style.display === "none") {
      allDeletions[i].style.display = "inline";
    } else {
      allDeletions[i].style.display = "none";
    }
  }
}

let currentPage = 1;
const totalPages = 10;

function updatePageContent() {
    document.getElementById('page-counter').textContent = `Page ${currentPage} of ${totalPages}`;
    
    document.querySelector('.previous').disabled = currentPage === 1;
    document.querySelector('.next').disabled = currentPage === totalPages;
}

function nextPage() {
    if (currentPage < totalPages) {
        currentPage++;
        updatePageContent();
    }
}

function previousPage() {
    if (currentPage > 1) {
        currentPage--;
        updatePageContent();
    }
}

updatePageContent();

// EXTRA: write a function that will display the text as a reading text by clicking on a button or another dropdown list, meaning that all the deletions are removed and that the additions are shown inline (not in superscript)

