

let create_editor () =
  (* Création du conteneur *)
  let div = Dom_html.createDiv Dom_html.document in
  div##style##width <- Js.string "400px";
  div##style##height <- Js.string "350px";
  (* Création de l'éditeur *)
  let editor = Ace.edit div in
  (* Création d'une nouvelle session avec un mode existant *)
  let default_text = Js.string "let x = 10" in
  let mode = Js.string "ace/mode/ocaml" in
  let session = Ace.createEditSession default_text mode in
  (* Affectation de la session à l'éditeur *)
  editor##setSession(session);
  (* Puis on ajoute notre div au <body> *)
  Dom.appendChild Dom_html.document##body div


let create_editor_with_new_mode () =
  (* Création du conteneur *)
  let div = Dom_html.createDiv Dom_html.document in
  div##style##width <- Js.string "400px";
  div##style##height <- Js.string "350px";
  (* Création de l'éditeur *)
  let editor = Ace.edit div in
  
  (* Définition des règles du parser *)
  let keywords = [ "let" ; "in" ; "begin" ; "end" ] in
  let keywords_regex = jsnew Js.regExp(Js.string (String.concat "|" keywords)) in
  let state_start = Ace.tokenizerState "start"
    [ "keyword.operator", keywords_regex, None ]
  in
  let rules = Ace.tokenizerRules [ state_start ] in
  (* Création du tokenizer contenant les règles *)
  let tokenizer = jsnew Ace.tokenizer(rules, Js.string "") in

  (* Création du nouveau mode (sans matchingBraceOutdent) *)
  let mode = Ace.mode tokenizer Js.undefined in
  (* Affectation du mode à l'éditeur *)
  editor##getSession()##setMode(mode);
  (Js.Unsafe.coerce Dom_html.window)##testes <- editor;
  (* On ajoute notre div au <body> *)
  Dom.appendChild Dom_html.document##body div
