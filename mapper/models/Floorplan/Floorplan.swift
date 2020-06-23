import Foundation
import ARKit

public class Floorplan: Codable {
    var walls: [Wall]
    var objects: [Object]
}
