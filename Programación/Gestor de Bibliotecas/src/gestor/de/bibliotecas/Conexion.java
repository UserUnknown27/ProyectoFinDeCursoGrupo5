
package gestor.de.bibliotecas;
import java.sql.*;

public class Conexion {
    static String url = "jdbc:mysql://172.26.195.61:3306/gestion_libreria";
    static String user = "usuario";
    static String pass = "1234";
    
    public static Connection conectar(){
        Connection con = null;
        try{
            con = DriverManager.getConnection(url,user,pass);
            System.out.println("Conexion correcta");
        }catch(SQLException e){
            e.printStackTrace();
        }
            return con;
    }
    
    
}
