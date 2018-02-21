xquery version "1.0-ml";

import module namespace  check-user-lib = "http://www.marklogic.com/data-explore/lib/check-user-lib" at "/server/lib/check-user-lib.xqy" ;
import module namespace cfg = "http://www.marklogic.com/data-explore/lib/config" at "/server/lib/config.xqy";

declare function local:remove-query() {
    let $name := map:get($cfg:getRequestFieldsMap, "name")
    let $docType := map:get($cfg:getRequestFieldsMap, "docType")
    let $_ := if ( fn:empty($name) or $name = '' ) then fn:error(xs:QName("ERROR"),"Name may not be empty.") else ()
    let $_ := if ( fn:empty($docType) or $docType = '' ) then fn:error(xs:QName("ERROR"),"DocType may not be empty.") else ()
    let $docs := /formQuery[queryName=$name and documentType=$docType]
    let $_ := $docs ! xdmp:document-delete(fn:base-uri(.))
    return ()
};

if (check-user-lib:is-logged-in() and (check-user-lib:is-wizard-user()))
then (local:remove-query())
else (xdmp:set-response-code(401, "User is not authorized."))