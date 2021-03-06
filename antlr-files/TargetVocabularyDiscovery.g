grammar TargetVocabularyDiscovery;

options {
  language = Java;
}

@header {
  package de.fuberlin.wiwiss.r2r.parser;
  
  import java.util.Set;
  import java.util.HashSet;
  import java.util.Map;
  import java.util.HashMap;
  import com.hp.hpl.jena.util.PrintUtil;
  import java.util.Collection;
  import de.fuberlin.wiwiss.r2r.discovery.*;
}

@lexer::header {
  package de.fuberlin.wiwiss.r2r.parser;
}

@lexer::members {
  public void recover(RecognitionException re) {
    String hdr = getErrorHeader(re);
    String msg = getErrorMessage(re, this.getTokenNames());
    
    throw new ParseException(hdr + " " + msg);
  }
  
  public void reportError(RecognitionException re) {
    String hdr = getErrorHeader(re);
    String msg = getErrorMessage(re, this.getTokenNames());
    
    throw new ParseException(hdr + " " + msg);
  }
}

@members {
  Map<String, String> prefixMap = new HashMap<String, String>();

  public void recover(IntStream input, RecognitionException re) {
    String hdr = getErrorHeader(re);
    String msg = getErrorMessage(re, this.getTokenNames());
    
    throw new ParseException(hdr + " " + msg);
  }
  
  public void reportError(RecognitionException re) {
    String hdr = getErrorHeader(re);
    String msg = getErrorMessage(re, this.getTokenNames());
    
    throw new ParseException(hdr + " " + msg);
  }
}

targetVocabulary returns [Collection<DiscoveryTargetVocabulary> targetVocabularies]
  : prefixDefs? v=vocabularyDefs
    { $targetVocabularies = $v.value; }
  ;

vocabularyDefs returns [Collection<DiscoveryTargetVocabulary> value]
  :
   { $value = new ArrayList<DiscoveryTargetVocabulary>(); }
   (vocabularyDef
     {
       $value.add($vocabularyDef.value);
     } 
   )*
  ;
  
vocabularyDef returns [DiscoveryTargetVocabulary value]
  :
  {
    String dataset = null;
    Map<String, String> termDatasetPairs = new HashMap<String, String>();
  } 
 '('   (entity=termWithDataset { termDatasetPairs.put($entity.term, $entity.dataset);}
    (',' entity=termWithDataset { termDatasetPairs.put($entity.term, $entity.dataset);} )* )?
 ')' ('^' ds=iriRef {dataset = $ds.value;})? '.'?
      {
        $value = new DiscoveryTargetVocabulary(termDatasetPairs, dataset);
      }
  ;
  
termWithDataset returns [String term, String dataset]
  : t=iriRef { $term = $t.value; $dataset = null;}
   ('^' ds=iriRef {$dataset = $ds.value;} )? 
  ;

prefixDefs: prefixDef ('.' prefixDef)* '.'?;

prefixDef
  : '@prefix' prefix=PNAME_NS IRI_REF  {
      String iri = $IRI_REF.text;
      prefixMap.put($prefix.text.substring(0, $prefix.text.length()-1), iri.substring(1, iri.length()-1));
  }
  ;

iriRef returns [String value]
   : IRI_REF
     { 
       String iri = $IRI_REF.text;
       $value = iri.substring(1, iri.length()-1);
     } 
   | prefixedName
   { 
     String qName = $prefixedName.text;
     String iri = PrintUtil.expandQname(qName);
     if(qName.equals(iri))
     {
       String[] prefixAndName = (qName.split(":"));
       iri = prefixMap.get(prefixAndName[0]);
       if(iri==null)
         throw new IllegalArgumentException("Uknown namespace prefix in target vocabulary: " + prefixAndName[0]);
       else {
         if(prefixAndName.length < 2)
           $value = iri;
         else
           $value = iri + prefixAndName[1];
       }  
     }
     else {
       $value = iri;
     }
   }
   ;
   
  prefixedName
   : p=PNAME_LN
//   | PNAME_NS
   ;

WS
  : ('\u0020' | '\u0009' | '\u000D' | '\u000A') {$channel = HIDDEN;}
  ;
  
IRI_REF
  : '<' (~('<' | '>' | '"' | '{' | '}' | '|' | '^' | '`' | '\\' | '\u0000'..'\u0020'))* '>'
  ;
  
PNAME_LN
  : PNAME_NS PN_LOCAL
  ;
  
PNAME_NS
  : PN_PREFIX ':'
  ;
  
fragment PN_CHARS_BASE
  : 'a'..'z'
  | 'A'..'Z'
  | '\u00C0'..'\u00D6'
  | '\u00D8'..'\u00F6'
  | '\u00F8'..'\u02FF'
  | '\u0370'..'\u037D'
  | '\u037F'..'\u1FFF'
  | '\u200C'..'\u200D'
  | '\u2070'..'\u218F'
  | '\u2C00'..'\u2FEF'
  | '\u3001'..'\uD7FF'
  | '\uF900'..'\uFDCF'
  | '\uFDF0'..'\uFFFD'
  ;
    
fragment PN_CHARS_U
  : PN_CHARS_BASE | '_'
  ;
  
fragment PN_LOCAL
  : (PN_CHARS_U | '0'..'9') ((PN_CHARS | '.')* PN_CHARS)?
  ;
  
PN_PREFIX
  : PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?
  ;
  
fragment PN_CHARS
  : PN_CHARS_U 
  | '-' 
  | '0'..'9'
  | '\u00B7'
  | '\u0300'..'\u036F'
  | '\u203F'..'\u2040'
  ;