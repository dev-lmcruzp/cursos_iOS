//: Playground - noun: a place where people can play

import UIKit
import AFNetworking

var str = "Hello, playground"

extension String {
    func reversa() -> String
    {
        print("Reservado")
        return "Hola"
    }
    
    func IntValue() -> Int {
        return Int(self)!
    }
    
    func validar() -> Bool {
        return self.characters.first == "A"
    }
}



Int("0")!

"0".IntValue()

"De".validar()
"A".validar()

extension UIImageView
{
    func loadPicture(url : String) {
        if url.characters.count < 7
        { return
        }
        do{
            let dato = try Data(contentsOf : URL(string : url)!)
            self.image = UIImage(data : dato)
        }
        catch{
            print ("Error: \(error))")
        }
    }
}

let imagen = UIImageView(image : UIImage(named : "botas"))

imagen.loadPicture(url: "http://vignette1.wikia.nocookie.net/pokemontowerdefensetwo/images/d/d5/Togepi_banner.png/revision/latest?cb=20160718043659")

