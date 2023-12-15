import {Proskomma} from "proskomma-core";


const pk = new Proskomma();
window.test = function (query, usfm) {
    console.log(JSON.stringify({query}, null, 2));
    try {
        pk.importDocument({lang: "eng", abbr: "ust"}, "usfm", usfm);
    } catch (e) {
        console.log(e.message);    
    }
    return JSON.stringify(pk.gqlQuerySync(query));
}