//This program prints the date on which bookings are open for a specified date
//on irctc

package main
import (
        "os"
        "fmt"
        "time"
)

func gettime_or_exit (date string) (time.Time) {
        t, err := time.Parse ("Jan 02, 2006", date)
        if err != nil {
                fmt.Println (err)
                os.Exit(-1)
        }
        return t
}

func main() {
        if len(os.Args) != 2 {
                fmt.Println ("Date (Ex: \"Aug 03, 2013\") should be given as argument")
                os.Exit(-1)
        }
        //According to irctc, we can book Aug 11th 2013 ticket on June 12th
        //Lets figure out the duration
        travelday := gettime_or_exit ("Aug 11, 2013")
        bookingday := gettime_or_exit ("Jun 12, 2013")
        timediff := travelday.Sub(bookingday)

        //Subtract this duration from the input to get the booking date
        travelday = gettime_or_exit (os.Args[1])
        bookingday = travelday.Add (-timediff)
        fmt.Println ("Booking for ", os.Args[1], " opens on: ", bookingday.Month(), bookingday.Day(), bookingday.Year())
}
