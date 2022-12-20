import java.io.*;

class EvaluatePostfix {

    final static int MAX = 20;
    static int i = 0; 
    static int[] p = new int[MAX]; 

    static int pop() {
        if (i == 0) {
            System.out.println("Invalid Postfix");
            System.exit(1);
        }
        
        i--;
        return (p[i]);
    } 
    
    static void push(int result) {
        p[i] = result;
        i++;
    } 

    static int calc(int x1, int ch, int x2) {
        int total = 0;
        
        switch (ch) {
            case '+':
                total = x1 + x2;
                break;
            case '-':
                total = x1 - x2;
                break;
            case '*':
                total = x1 * x2;
                break;
            case '/':
                if (x2 != 0) total = x1 / x2;
                else {
                    System.out.println("Divide by zero");
                    System.exit(1);
                }
                break;
        } 
        
        return total;
    } 
    
    public static void main(String args[]) throws IOException {
        int result = 0, ch, x1, x2, number;
        
        System.out.print("Postfix (input): ");

        do {
            ch = (int) System.in.read();
            
            if (ch != ' ') {
                number = 0;
                
                while ((ch >= '0') && (ch <= '9')) {
                    number = 10 * number + (ch - 48);
                    ch = (int) System.in.read();
                }
                
                if ((ch == '+') || (ch == '-') || (ch == '*') || (ch == '/')) {
                    x2 = pop();
                    x1 = pop();
                    result = calc(x1, ch, x2);
                    push(result);
                }
                else if (ch != '=')
                    push(number);
            }
        } while (ch != '=');
        
        if (i == 1)
            System.out.println("Postfix Evaluation: " + p[0]);
        else
            System.out.println("Invalid Postfix");
    } 
} 
