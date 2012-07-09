package helpers;
import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.print.PageFormat;
import java.awt.print.Printable;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;

import system.exceptions.PrintCancelledExcpetion;

public class TextPrinter implements Printable {
   /**
    * Default font size, 12 point
    */
   public static final int DEFAULT_FONT_SIZE = 12;

   /**
    * Default type name, Serif
    */
   public static final String DEFAULT_FONT_NAME = "Serif";

   private PrinterJob job;
   private String typeName;
   private int typeSize;
   private Font typeFont;
   private Font typeFontBold;
   private String [] header;
   private String [] body;

   /**
    * Create a TextPrinter object with the default type
    * font and size.
    */
   public TextPrinter() {
       this(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE);
   }

   /**
    * Create a TextPrinter object ready to print text
    * with a given font and type size.
    */
   public TextPrinter(String name, int size) 
   {
       if (size < 3 || size > 127) {
           throw new IllegalArgumentException("Type size out of range");
       }
       typeName = name;
       typeSize = size;
       typeFont = new Font(typeName, Font.PLAIN, typeSize);
       typeFontBold = new Font(typeName, Font.BOLD, typeSize);
       job = null;
   }

   /**
    * Initialize the printer job.
    */
   protected void init() {
       job = PrinterJob.getPrinterJob();
   }
   
   /**
    * Initialize the print job, and return the base number of
    * characters per line with the established font size and
    * font.  This is really just a guess, because we can't
    * get the font metrics yet.
    */
   public int getCharsPerLine() {
       if (job == null) {
           init();
       }
       PageFormat pf;
       pf = job.defaultPage();
       double width = pf.getImageableWidth(); // in 72nd of a pt
       double ptsize = typeFont.getSize();
       double ptwid = ptsize * 3 / 4;
       double cnt = (width / ptwid); 
       return (int)(Math.round(cnt));
   }

   /**
    * Print some text.  Headers are printed first, in bold,
    * followed by the body text, in plain style.  If the
    * boolean argument interactive is set to true, then
    * the printer dialog gets shown.
    *
    * Either array may be null, in which case they are treated
    * as empty.  
    *
    * This method returns true if printing was initiated, or
    * false if the user cancelled printer.  This method may 
    * throw PrinterException if printing could not be started.
 * @throws Exception 
    */
   public boolean doPrint(String [] header, String [] body, 
                  boolean interactive) 
       throws Exception
   {
       if (job == null) {
           init();
       }
       if (interactive) try {
           if (job.printDialog()) {
               // we are going to print
           } else {
        	   throw new PrintCancelledExcpetion("Printing job cancelled");
           }
       } catch (PrintCancelledExcpetion pe) {
    	   throw new Exception(pe.getMessage());
       } catch (Exception pe) {
           throw new Exception("Failed to print");
       }

       job.setPrintable((Printable) this);
       this.header = header;
       this.body = body;
       job.print();
       job = null;  // we are no longer initialized
       return true;
   }
   
   /**
    * Perform printing according to the Java printing 
    * model.  NEVER CALL THIS DIRECTLY!  It will be 
    * called by the PrinterJob as necessary.  This
    * method always returns Printable.NO_SUCH_PAGE for
    * any page number greater than 0.
    */
   public int print(Graphics graphics,
                PageFormat pageFormat,
                int pageIndex)
         throws PrinterException
   {
       if (pageIndex != 0) {
           return NO_SUCH_PAGE;
       }
       FontMetrics fm;
       graphics.setFont(typeFont);
       graphics.setColor(Color.black);
       fm = graphics.getFontMetrics();

       // fill in geometric and rendering guts here
       int i;
       double x, y;
       x = pageFormat.getImageableX();
       y = pageFormat.getImageableY() + fm.getMaxAscent();

       // do the headings
       if (header != null) {
           graphics.setFont(typeFontBold);
           for(i = 0; i < header.length; i++) {
               graphics.drawString(header[i],(int)x, (int)y);
               y += fm.getHeight();
           }
       }

       // do the body
       if (body != null) {
           graphics.setFont(typeFont);
           for(i = 0; i < body.length; i++) {
               graphics.drawString(body[i],(int)x,(int)y);
               y += fm.getHeight();
           }
       }

       return PAGE_EXISTS;
   }
}
