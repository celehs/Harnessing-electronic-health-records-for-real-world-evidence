package com.Angus;

import java.io.FileNotFoundException;
import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Scanner;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.FileWriter;
import java.util.Map;
import java.text.BreakIterator;
import java.util.Locale;
import java.io.File;
import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.sun.istack.internal.localization.NullLocalizable;
import edu.harvard.hsph.biostats.nile.InconsistentPhraseDefinitionException;
import edu.harvard.hsph.biostats.nile.NaturalLanguageProcessor;
import edu.harvard.hsph.biostats.nile.SemanticObject;
import edu.harvard.hsph.biostats.nile.SemanticRole;
import edu.harvard.hsph.biostats.nile.Sentence;

public class main
{
    static Map<String,String> cuisty_dict = new HashMap();
    static Map<String,String> termscui_dict = new HashMap();



    public static void main(String[] args) throws IOException {
        //the text

        String article = new String();

        article = readPDFFile("data/Section.pdf");
        //delete the \n
        article = article.replaceAll("\\n", "");

        //get the dictionary of cui and semantictype
        String cuisty_dict_path = "data/cuisty_dict.txt"; //the dictionary of cui and semantictype
        init_cuistydict(cuisty_dict_path);

        String folder_path = "data/cui_dict";
        File file = new File(folder_path);
        File[] fs = file.listFiles();
        for(File f:fs)
        {
            get_termscuidict(f,article);  // get {terms:cui} dict
        }

        write_file("result_section.txt",article);
    }


    public static String readPDFFile(String filePath)
    {
        String content = "";
        try {
            // Load PDF document
            PDDocument document = PDDocument.load(new File(filePath));

            // initial the stripper
            PDFTextStripper pdfTextStripper = new PDFTextStripper();

            // extract text
            content = pdfTextStripper.getText(document);

            // close the document
            document.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return content;
    }


    static private void get_termscuidict(File read_file,String article)
    {
        // Prepare the NLP environment
        NaturalLanguageProcessor nlp = null;
        try
        {
            nlp = new NaturalLanguageProcessor();
        } catch (InconsistentPhraseDefinitionException e)
        {
            System.err.println(e.getMessage());
        }

        Scanner sc = null;
        try
        {
            sc = new Scanner(read_file);
            while (sc.hasNextLine())
            {
                String line = sc.nextLine();
                line = line.split("//")[0];
                if (line.trim().equals(""))
                    continue;
                String[] entry = line.split("\\|");
                String text = entry[0].trim().toLowerCase();
                String code = null;
                if (entry.length > 1)
                    code = entry[1].trim().toUpperCase();
                else
                    code = text.toUpperCase();
                try {
                    nlp.addPhrase(text, code, SemanticRole.OBSERVATION);
                } catch (InconsistentPhraseDefinitionException e) {
                    System.err.println(e.getMessage());
                }
            }
        } catch (FileNotFoundException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
        sc.close();

        try {
            sc = new Scanner(new File("/Users/sinianzhang/Desktop/Minnesota/NILE/data/dict_locations.txt"));
            while (sc.hasNextLine()) {
                String line = sc.nextLine();
                line = line.split("//")[0];
                if (line.trim().equals(""))
                    continue;
                String[] entry = line.split("\\|");
                String text = entry[0].trim().toLowerCase();
                String code = null;
                if (entry.length > 1)
                    code = entry[1].trim().toUpperCase();
                else
                    code = text.toUpperCase();
                try {
                    nlp.addPhrase(text, code, SemanticRole.LOCATION);
                } catch (InconsistentPhraseDefinitionException e) {
                    System.err.println(e.getMessage());
                }
            }
        } catch (FileNotFoundException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
        sc.close();

        try {
            sc = new Scanner(new File("/Users/sinianzhang/Desktop/Minnesota/NILE/data/dict_modifiers.txt"));
            while (sc.hasNextLine()) {
                String line = sc.nextLine();
                line = line.split("//")[0];
                if (line.trim().equals(""))
                    continue;
                String[] entry = line.split("\\|");
                String text = entry[0].trim().toLowerCase();
                String code = null;
                if (entry.length > 1)
                    code = entry[1].trim().toUpperCase();
                else
                    code = text.toUpperCase();
                try {
                    nlp.addPhrase(text, code, SemanticRole.MODIFIER);
                } catch (InconsistentPhraseDefinitionException e) {
                    System.err.println(e.getMessage());
                }
            }
        } catch (FileNotFoundException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
        sc.close();

        for (Sentence s : nlp.digTextLine(article))
        {
            for (SemanticObject obj : s.getSemanticObjs())
            {
                if (obj.getSemanticRole() != SemanticRole.OBSERVATION)
                {
                    continue;
                }
                if (!termscui_dict.containsKey(obj.getText().toString()))
                {
                    termscui_dict.put(obj.getText().toString(), obj.getCode().toString());
                }
            }
        }
    }

    static private void write_file(String write_path,String article)
    {
        //convert to lower case
        article = article.toLowerCase();

        // Prepare the NLP environment
        NaturalLanguageProcessor nlp = null;
        try
        {
            nlp = new NaturalLanguageProcessor();
        } catch (InconsistentPhraseDefinitionException e)
        {
            System.err.println(e.getMessage());
        }

        try
        {
            //open the file
            File write_file = new File(write_path);
            if(!write_file.exists())
            {
                write_file.createNewFile();
            }

            //write the column names
            FileWriter fw=new FileWriter(write_path);
            fw.write("Key"+ " | " + "Superior Key"+ " | " + "Key Cui" + " | " + "Superior Key Cui" + " | " + "Key Semantictype" + " | " + "Superior Key Semantictype" + " | " + "Key Location" + " | " + "Superior Key Location" +"\n" );

            //get the sentence in the article
            int location,sup_location,sentence_location= 0;
            for(String sentence : article.split("[.?!][^A-Z0-9\\)](?![^(]*\\()\\s*")) //split the article into sentence
            {

                sentence_location = article.indexOf(sentence) + 1; //the location of sentence

                for(String key:termscui_dict.keySet())
                {
                    //if key is in sentence & key is not a data or character
                    if(sentence.contains(key)&(!key.matches("[-+]?[0-9]*\\.?[0-9]+%?|^[a-zA-Z]$")))
                    {
                        String sup_key = key;

                        for(String tmp_key:termscui_dict.keySet())
                        {
                            if(sentence.contains(tmp_key) & (tmp_key.endsWith(sup_key + " ") | tmp_key.startsWith(sup_key + " ") | tmp_key.contains(" " + sup_key+ " ")))
                            {
                                sup_key = tmp_key;
                            }
                        }

                        //get semantic type of the cui
                        String semantictype = get_semantictype(termscui_dict.get(key));
                        String sup_semantictype = get_semantictype(termscui_dict.get(sup_key));

                        //find the location of terms
                        sup_location =sentence.indexOf(sup_key) + sentence_location;
                        location =sup_key.indexOf(key) + sup_location ;

                        fw.write(key+ " | " + sup_key+ " | " + termscui_dict.get(key) +" | "  + termscui_dict.get(sup_key) + "|" + semantictype+ " | " + sup_semantictype + " | " + location + " | " + sup_location+   "\n" );
                    }
                }
            }

            //some terms are recognized by nile,but not in the article

            //read the contents of this file
            String encoding = "UTF-8";
            File read_file = new File(write_path);
            Long filelength = read_file.length();
            byte[] contents = new byte[filelength.intValue()];
            try
            {
                FileInputStream in = new FileInputStream(read_file);
                in.read(contents);
                in.close();
            } catch (FileNotFoundException e)
            {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            String filecontents=  new String(contents, encoding);

            //write the specific contents
            for(String key:termscui_dict.keySet())
            {
                if((!filecontents.contains(key)) & (!key.matches("[-+]?[0-9]*\\.?[0-9]+%?|^[a-zA-Z]$")))
                {
                    String sup_key = key;
                    for(String tmp_key:termscui_dict.keySet())
                    {
                        if( tmp_key.endsWith(sup_key + " ") | tmp_key.startsWith(sup_key + " ") | tmp_key.contains(" " + sup_key+ " "))
                        {
                            sup_key = tmp_key;
                        }
                    }
                    //get semantic type of the cui
                    String semantictype = get_semantictype(termscui_dict.get(key));
                    String sup_semantictype = get_semantictype(termscui_dict.get(sup_key));

                    //find the location of terms
                    sup_location =article.indexOf(sup_key);
                    location =sup_key.indexOf(key) + sup_location ;

                    fw.write(key+ " | " + sup_key+ " | " + termscui_dict.get(key) +" | "  + termscui_dict.get(sup_key) + "|" + semantictype+ " | " + sup_semantictype + " | " + location + " | " + sup_location+   "\n" );
                }
            }

            fw.flush();
            fw.close();

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    static private String get_semantictype(String cui_value)
    {
        String semantictype = new String();
        cui_value = cui_value.replace("[","");
        cui_value = cui_value.replace("]","");
        cui_value = cui_value.trim();
        String[] cui = cui_value.split(",");
        for(int i= 0;i<cui.length;i++)
        {
            String c = cui[i].trim();
            if(i==0){semantictype = " [ " + cuisty_dict.get(c.trim()) + " ] ";}
            else
            {
                semantictype = semantictype +  " ; " +  " [ " +  cuisty_dict.get(c.trim()) + " ] ";
            }
        }

        return semantictype;
    }
    static private void init_cuistydict(String path)
    {
        Scanner sc = null;
        String semantictype = null;
        String cui_value = null;
        try {
            sc = new Scanner(new File(path));
            while (sc.hasNextLine())
            {
                String line = sc.nextLine();
                String[] entry = line.split("\\|");
                cui_value = entry[0].trim();
                semantictype = entry[1].trim().toLowerCase();
                cuisty_dict.put(cui_value,semantictype);
            }
        }
        catch (FileNotFoundException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
    }
}

