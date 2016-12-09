//
//  ViewController.swift
//  AppDemo
//
//  Created by STI on 05/12/16.
//  Copyright © 2016 integrait. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetalleViewControllerDelegate, AgregarViewControllerDelegate {
 
    //MARK: - Declaraciones
    var rootRef:FIRDatabaseReference?
    var filaSeleccionada = -1
    var datos = [
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25),
                    ("Luis", 24), ("Miguel", 25)
            ]
    var esEdicion : Bool = false

    //var arreglo: [(nombre: String, edad: Int, genero: String, foto: String)] = []
    var arreglo: [Persona] = [Persona]()
    
    
    @IBOutlet weak var btnBoton: UIButton!
    @IBOutlet weak var tblTabla: UITableView!
    
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var lblNombreUsuario: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgFoto.image = UIImage(named: "botas")
        lblNombreUsuario.text = "User name"
        rootRef = FIRDatabase.database().reference()
        
        arreglo = Persona.selectTodos()
        tblTabla.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.rootRef!.child("Base").observe(.value, with: { (snap : FIRDataSnapshot) in
            print("dato: \(snap.value)")
            
            self.lblNombreUsuario.text = "\(snap.value!)"
            
        } )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arreglo.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminar = UITableViewRowAction(style: .destructive, title: "Borrar", handler: borrarFila)
        let editar = UITableViewRowAction(style: .normal, title: "Editar", handler: editarFila)
        return [eliminar, editar]
    }
    
    /*
     let alert = UIAlertController(title: "Error", message: "Los campos introducidos no son validos.", preferredStyle: .actionSheet)
     let defaultAction = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in })
     let defaultActionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: { (UIAlertAction) in
     self.navigationController!.popViewController(animated: true)
     })
     alert.addAction(defaultAction)
     alert.addAction(defaultActionCancel)
     
     present(alert, animated:  true, completion: { })
     */
    
    func borrarFila(sender: UITableViewRowAction, indexPath: IndexPath ){
        Persona.eliminar(persona: arreglo[indexPath.row])
        arreglo.remove(at: indexPath.row)
        tblTabla.deleteRows(at: [indexPath], with: .fade)
        
        /*
        datos.remove(at: indexPath.row)
        tblTabla.reloadData()
        */
    }
    
    func editarFila(sender: UITableViewRowAction, indexPath: IndexPath ){
        esEdicion = true
        filaSeleccionada = indexPath.row
        performSegue(withIdentifier: "AgregarSegue", sender: sender)
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    @IBAction func btnAgregar_Click(_ sender: Any) {
        performSegue(withIdentifier: "AgregarSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let filaInpar =  (indexPath.row % 2 == 0)
        //let proto = filaInpar ? "proto1" : "proto1"
        
        //let vista = tableView.dequeueReusableCell(withIdentifier: proto, for: indexPath) as! FilaTableViewCell
        
        let vista = tableView.dequeueReusableCell(withIdentifier: "proto1") as! FilaTableViewCell
        /*if indexPath.row >= arreglo.count
        {
            return vista
        }*/
        
        
        let dato = arreglo[indexPath.row]
        dato.edad = Int16(indexPath.row)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        vista.lblDerecha.text = "\(dato.nombre!)"
        vista.lblIzquierda.text = "\(dato.edad)"
        
        if(dato.genero == "m"){
            vista.imfFila.image = UIImage(named: "user_female")
        }else{
            vista.imfFila.image = UIImage(named: "user_male")
        }

        /*if filaInpar{
            vista.lblDerecha.text = "\(datos[indexPath.row].1)"
            vista.lblIzquierda.text = datos[indexPath.row].0
        }else{
            vista.lblIzquierda.text = "\(datos[indexPath.row].1)"
            vista.lblDerecha.text = datos[indexPath.row].0
        }*/
        
        vista.imfFila.DownLoadData(url: dato.foto!)
        
        //let idFacebook = FBSDKAccessToken.current().userID
        
        //lef userName = FBSDKAccessToken.current().
        
        //let url = URL(string : "http://graph.facebook.com/\(idFacebook!)/picture?type=large")
        
        /*vista.imfFila.loadPicture(url: "http://graph.facebook.com/\(idFacebook!)/picture?type=large")*/
        /*
        let dato : Data?
        do{
            dato = try Data(contentsOf : url!)
            vista.imfFila.image = UIImage(data: dato!)
        } catch{
            dato = nil
            print("Error cargando la imagen.! \(error.localizedDescription)")
            vista.imfFila.image = UIImage(named: "botas")
        }
        */
        
        
        return vista
    }
    
    // MARK: - UIView Delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "DetalleSegue":
                let view = segue.destination as! DetalleViewController
                view.numeroDeFila = filaSeleccionada
                view.dato = datos[filaSeleccionada].0
                view.datoNumero = datos[filaSeleccionada].1
                view.delegado = self
                break
            case "AgregarSegue" :
                let view = segue.destination as! AgregarViewController
                if esEdicion
                {
                    view.fila = filaSeleccionada
                    view.edad = datos[filaSeleccionada].1
                    view.nombre = datos[filaSeleccionada].0
                    esEdicion = false
                }
                view.delegado = self
                break
            default:
                break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Fila \(indexPath.row)")
        filaSeleccionada = indexPath.row
        //DetalleSegue
        performSegue(withIdentifier: "DetalleSegue", sender: self)
    }
    
    // MARK - DetalleView Delegates
    func numeroCambiado(numero: Int) {
        print("Nùmero cambiado \(numero)")
        
        datos[numero].1 = datos[numero].1 + 1
        tblTabla.reloadData()
    }
    
    
    // MARK : - Agregar Delegates
    func agregarRegistro(nombre: String, edad: Int) {
        let persona = Persona()
        persona.nombre = nombre
        persona.edad = Int16(edad)
        
        //datos.append((nombre, edad))
        tblTabla.reloadData()
    }
    
    func modificarRegistro(nombre: String, edad: Int, fila : Int) {
        datos[fila].1 = edad
        datos[fila].0 = nombre
        tblTabla.reloadData()
    }

    
    @IBAction func btnRefrescarLista(_ sender: Any) {
        sincronizar()
    }
    
    
    @IBAction func btnRefrescarImgen_Click(_ sender: Any) {
        let valor = Int(lblNombreUsuario.text!)!
        rootRef?.child("Base").setValue(valor + 1)
        
        
        let idFacebook = FBSDKAccessToken.current().userID
        
        //lef userName = FBSDKAccessToken.current().
        
         imgFoto.loadPicture(url: "http://graph.facebook.com/\(idFacebook!)/picture?type=large")
        /*
        let url = URL(string : "http://graph.facebook.com/\(idFacebook!)/picture?type=large")
        let dato : Data?
        do{
            dato = try Data(contentsOf : url!)
            imgFoto.image = UIImage(data: dato!)
        } catch{
            dato = nil
            print("Error cargando la imagen.! \(error.localizedDescription)")
            imgFoto.image = UIImage(named: "botas")
        }*/
        
    }
    
    func sincronizar(){
        let url = URL(string: "http://kke.mx/demo/contactos2.php")
        
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 1000)
        
        request.httpMethod = "GET"
        
        //request.httpBody = Data(base64Encode: "dato1:23")
        
        //let das = data?.base64EncodedString()
        //let dat = Data(base64Encoded: "ABABABABABA==")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            guard(error == nil)else{
                print("Ocurrió un error con la petición: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else{
                print("Ocurrió un error con la respuesta.")
                return
            }
            
            if(!(statusCode >= 200 && statusCode <= 299)){
                print("Respuesta no válida")
            }
            
            let cad = String(data: data!, encoding: .utf8)
            print("Response: \(response!.description)")
            print("error: \(error)")
            print("data: \(cad!)")
            
            var parseResult: Any!
            do{
                parseResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            }catch{
                parseResult = nil
                print("Error: \(error)")
                return
            }
            
            guard let datos = (parseResult as? Dictionary<String, Any?>)?["datos"] as! [Dictionary<String, Any>]! else{
                print("Error: \(error)")
                return
            }
            
            self.arreglo.removeAll()
            
            
            let resultado = Persona.agregarTodos(datos: datos)
            /*
            print("Se agregaron \(resultado.agregados) registros")
            print("Se midificaron \(resultado.modificados) registros")
            print("Errores producidos \(resultado.errores)")
             */
            /*
            for d in datos{
             let nombre = (d["nombre"] as! String)
             let edad = (d["edad"] as! Int)
             let foto = (d["foto"] as! String)
             let genero = (d["genero"] as! String)
             
             self.arreglo.append((nombre: nombre, edad: edad, genero: genero, foto: foto))
             }
            */
            
            self.arreglo = Persona.selectTodos()
            //self.arreglo = Persona.selectNombre(nombre: "Alan")
            
            self.tblTabla.reloadData()
        })
        
        task.resume()
    }

}
