import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: const CineBookApp(),
    ),
  );
}

const Color pageBg = Color(0xFF101018);
const Color panelBg = Color(0xFF1B1B27);
const Color accent = Color(0xFFFFB547);
const Color muted = Color(0xFFAAAAB8);

class Movie {
  final String title, genre, duration, rating, description, emoji;
  final Color color;
  final double price;

  const Movie({
    required this.title,
    required this.genre,
    required this.duration,
    required this.rating,
    required this.description,
    required this.emoji,
    required this.color,
    required this.price,
  });
}

const movies = [
  Movie(
    title: 'Interstellar', genre: 'Sci-Fi • Adventure', duration: '2h 49m',
    rating: '8.7', emoji: '🚀', color: Color(0xFF344B72), price: 180,
    description: 'A team of explorers travels beyond this galaxy to discover whether mankind has a future among the stars.',
  ),
  Movie(
    title: 'The Batman', genre: 'Action • Crime', duration: '2h 56m',
    rating: '7.8', emoji: '🦇', color: Color(0xFF713B42), price: 160,
    description: 'When a mysterious villain leaves clues, Batman must uncover the truth hidden beneath Gotham City.',
  ),
  Movie(
    title: 'Spider-Verse', genre: 'Animation • Action', duration: '2h 20m',
    rating: '8.6', emoji: '🕸️', color: Color(0xFF8B3C62), price: 150,
    description: 'Miles Morales swings into a multiverse adventure alongside heroes from different dimensions.',
  ),
  Movie(
    title: 'Dune: Part Two', genre: 'Sci-Fi • Drama', duration: '2h 46m',
    rating: '8.5', emoji: '🏜️', color: Color(0xFF9A633B), price: 200,
    description: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against those who destroyed his family.',
  ),
];

class Booking {
  final String movie, date, time;
  final List<String> seats;
  final double total;
  Booking({required this.movie, required this.date, required this.time,
    required this.seats, required this.total});
}

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void addBooking(Booking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }
}

class CineBookApp extends StatelessWidget {
  const CineBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: pageBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent, brightness: Brightness.dark,
          surface: panelBg,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: pageBg, foregroundColor: Colors.white,
          elevation: 0, centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: panelBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onBookings: () => setState(() => tab = 1)),
      const MyBookingsScreen(),
    ];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panelBg,
        indicatorColor: accent.withOpacity(.18),
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie_outlined), selectedIcon: Icon(Icons.movie), label: 'Movies'),
          NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), selectedIcon: Icon(Icons.confirmation_number), label: 'My Bookings'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onBookings;
  const HomeScreen({super.key, required this.onBookings});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 760;
      final columns = constraints.maxWidth >= 1050 ? 4 : (wide ? 3 : 2);
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 20, vertical: 22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.local_movies, color: pageBg, size: 25),
                  ),
                  const SizedBox(width: 10),
                  const Text('CineBook', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    tooltip: 'My bookings',
                    onPressed: onBookings,
                    icon: const Icon(Icons.confirmation_number_outlined),
                  ),
                ]),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF49385F), Color(0xFF222A46)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('YOUR NEXT MOVIE NIGHT', style: TextStyle(color: accent, letterSpacing: 1.4, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Big stories.\nBig screen.', style: TextStyle(fontSize: wide ? 34 : 29, fontWeight: FontWeight.bold, height: 1.12)),
                    const SizedBox(height: 12),
                    const Text('Find a seat. Grab some popcorn. Enjoy the show.', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 18),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: pageBg),
                      onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MovieCatalogScreen(),
                            ),
                          );
                        },
                      child: const Text('Explore movies'),
                    ),
                  ]),
                ),
                const SizedBox(height: 28),
                const Text('Now Showing', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text('Pick a movie for your next outing', style: TextStyle(color: muted)),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16, mainAxisSpacing: 18,
                childAspectRatio: wide ? .78 : .67,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => MovieCard(movie: movies[index]),
                childCount: movies.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      );
    });
  }
}

class MovieCatalogScreen extends StatelessWidget {
  const MovieCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Movies'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1050
              ? 4
              : constraints.maxWidth >= 760
                  ? 3
                  : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 18,
              childAspectRatio: 0.67,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie))),
      child: Card(
        color: panelBg, clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(fit: StackFit.expand, children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [movie.color, movie.color.withOpacity(.45)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: Center(child: Text(movie.emoji, style: const TextStyle(fontSize: 70))),
              ),
              Positioned(top: 10, right: 10, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                child: Row(children: [const Icon(Icons.star, color: accent, size: 14), const SizedBox(width: 4), Text(movie.rating, style: const TextStyle(fontWeight: FontWeight.bold))]),
              )),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 13),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(movie.genre, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 11)),
              const SizedBox(height: 10),
              Row(children: [
                Text('₹${movie.price.toInt()} onwards', style: const TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 12)),
                const Spacer(), const Icon(Icons.arrow_forward, size: 16, color: accent),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie details')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 260, width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(colors: [movie.color, movie.color.withOpacity(.45)]),
                ),
                child: Center(child: Text(movie.emoji, style: const TextStyle(fontSize: 110))),
              ),
              const SizedBox(height: 22),
              Text(movie.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 9),
              Wrap(spacing: 16, runSpacing: 8, children: [
                _InfoChip(icon: Icons.category_outlined, text: movie.genre),
                _InfoChip(icon: Icons.schedule, text: movie.duration),
                _InfoChip(icon: Icons.star, text: movie.rating),
              ]),
              const SizedBox(height: 20),
              const Text('About the movie', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(movie.description, style: const TextStyle(color: muted, height: 1.6)),
              const SizedBox(height: 26),
              SizedBox(width: double.infinity, child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: pageBg, padding: const EdgeInsets.all(16)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeatSelectionScreen(movie: movie))),
                child: Text('Book tickets • ₹${movie.price.toInt()} per seat'),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 16, color: accent),
    label: Text(text),
    backgroundColor: panelBg,
    side: BorderSide.none,
  );
}

class SeatSelectionScreen extends StatefulWidget {
  final Movie movie;
  const SeatSelectionScreen({super.key, required this.movie});
  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<String> selected = {};
  final Set<String> occupied = {'A3', 'A4', 'B5', 'C2', 'D6', 'E1'};
  String showTime = '6:30 PM';
  String showDate = 'Today';

  @override
  Widget build(BuildContext context) {
    final total = selected.length * widget.movie.price;
    return Scaffold(
      appBar: AppBar(title: const Text('Select your seats')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.movie.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text('Choose your show', style: TextStyle(color: muted)),
              const SizedBox(height: 18),
              const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 9),
              Wrap(spacing: 8, children: ['Today', 'Tomorrow', 'Wed, 11 Nov'].map((date) =>
                ChoiceChip(label: Text(date), selected: showDate == date,
                  selectedColor: accent, onSelected: (_) => setState(() => showDate = date),
                  labelStyle: TextStyle(color: showDate == date ? pageBg : Colors.white),
                )).toList()),
              const SizedBox(height: 17),
              const Text('Showtime', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 9),
              Wrap(spacing: 8, children: ['1:30 PM', '6:30 PM', '9:45 PM'].map((time) =>
                ChoiceChip(label: Text(time), selected: showTime == time,
                  selectedColor: accent, onSelected: (_) => setState(() => showTime = time),
                  labelStyle: TextStyle(color: showTime == time ? pageBg : Colors.white),
                )).toList()),
              const SizedBox(height: 25),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: panelBg, borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  const Icon(Icons.screen_rotation_alt, color: muted, size: 25),
                  const SizedBox(height: 4),
                  const Text('SCREEN THIS WAY', style: TextStyle(color: muted, letterSpacing: 2, fontSize: 10)),
                  const SizedBox(height: 15),
                  Container(height: 4, width: 250, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 20),
                  for (final row in ['A', 'B', 'C', 'D', 'E'])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(width: 20, child: Text(row, style: const TextStyle(color: muted))),
                        for (int col = 1; col <= 6; col++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SeatButton(
                              seat: '$row$col',
                              occupied: occupied.contains('$row$col'),
                              selected: selected.contains('$row$col'),
                              onTap: () => setState(() {
                                final seat = '$row$col';
                                if (selected.contains(seat)) { selected.remove(seat); }
                                else if (!occupied.contains(seat)) { selected.add(seat); }
                              }),
                            ),
                          ),
                        const SizedBox(width: 20),
                      ]),
                    ),
                  const SizedBox(height: 12),
                  const Wrap(spacing: 16, runSpacing: 8, alignment: WrapAlignment.center, children: [
                    _Legend(color: Color(0xFF424252), label: 'Available'),
                    _Legend(color: accent, label: 'Selected'),
                    _Legend(color: Color(0xFF777783), label: 'Occupied'),
                  ]),
                ]),
              ),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: Text('${selected.length} seat(s) selected', style: const TextStyle(color: muted))),
                Text('Total: ₹${total.toInt()}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: accent)),
              ]),
              const SizedBox(height: 15),
              SizedBox(width: double.infinity, child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: pageBg, padding: const EdgeInsets.all(16)),
                onPressed: selected.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CheckoutScreen(
                    movie: widget.movie, seats: selected.toList()..sort(),
                    date: showDate, time: showTime,
                  ),
                )),
                child: const Text('Continue to checkout'),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}

class SeatButton extends StatelessWidget {
  final String seat;
  final bool occupied, selected;
  final VoidCallback onTap;
  const SeatButton({super.key, required this.seat, required this.occupied, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final color = occupied ? const Color(0xFF777783) : (selected ? accent : const Color(0xFF424252));
    return Tooltip(message: occupied ? 'Seat unavailable' : 'Seat $seat', child: InkWell(
      onTap: occupied ? null : onTap,
      borderRadius: BorderRadius.circular(7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 34, height: 31,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7),
          border: Border.all(color: selected ? Colors.white : Colors.transparent, width: 1.2)),
        child: Center(child: Text(seat, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: selected ? pageBg : Colors.white))),
      ),
    ));
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
    const SizedBox(width: 5), Text(label, style: const TextStyle(color: muted, fontSize: 11)),
  ]);
}

class CheckoutScreen extends StatefulWidget {
  final Movie movie;
  final List<String> seats;
  final String date, time;
  const CheckoutScreen({super.key, required this.movie, required this.seats, required this.date, required this.time});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.seats.length * widget.movie.price;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Your booking', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Card(color: panelBg, child: Padding(padding: const EdgeInsets.all(16), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.movie.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${widget.date}  •  ${widget.time}', style: const TextStyle(color: muted)),
                const SizedBox(height: 5),
                Text('Seats: ${widget.seats.join(', ')}', style: const TextStyle(color: muted)),
                const Divider(height: 25),
                Row(children: [const Text('Total amount'), const Spacer(), Text('₹${total.toInt()}', style: const TextStyle(color: accent, fontSize: 21, fontWeight: FontWeight.bold))]),
              ],
            ))),
            const SizedBox(height: 22),
            const Text('Contact details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Form(key: formKey, child: Column(children: [
              TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)),
                validator: (value) => value == null || value.trim().length < 2 ? 'Please enter your name' : null),
              const SizedBox(height: 12),
              TextFormField(controller: emailController, keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined)),
                validator: (value) => value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim()) ? 'Enter a valid email address' : null),
            ])),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: pageBg, padding: const EdgeInsets.all(16)),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final booking = Booking(movie: widget.movie.title, date: widget.date, time: widget.time,
                  seats: widget.seats, total: total);
                context.read<BookingProvider>().addBooking(booking);
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => BookingSuccessScreen(booking: booking, customer: nameController.text.trim())),
                  (route) => route.isFirst);
              },
              child: const Text('Confirm booking'),
            )),
            const SizedBox(height: 10),
            const Center(child: Text('Demo application • No real payment is processed', style: TextStyle(color: muted, fontSize: 11))),
          ],
        )),
      )),
    );
  }
}

class BookingSuccessScreen extends StatelessWidget {
  final Booking booking;
  final String customer;
  const BookingSuccessScreen({super.key, required this.booking, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking confirmed'), automaticallyImplyLeading: false),
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.check_circle, color: Color(0xFF65D6A2), size: 76),
          const SizedBox(height: 14),
          const Text('You’re going to the movies!', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          const Text('Your demo ticket is ready.', style: TextStyle(color: muted)),
          const SizedBox(height: 24),
          Card(color: panelBg, child: Padding(padding: const EdgeInsets.all(20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.local_movies, color: accent), const SizedBox(width: 8), const Text('CINEBOOK TICKET', style: TextStyle(letterSpacing: 1.3, fontWeight: FontWeight.bold)), const Spacer(), const Icon(Icons.qr_code_2, size: 38)]),
              const Divider(height: 28),
              Text(booking.movie, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Booked by $customer', style: const TextStyle(color: muted)),
              const SizedBox(height: 18),
              _TicketLine(label: 'Date', value: booking.date),
              _TicketLine(label: 'Showtime', value: booking.time),
              _TicketLine(label: 'Seats', value: booking.seats.join(', ')),
              _TicketLine(label: 'Total paid', value: '₹${booking.total.toInt()}'),
            ],
          ))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: pageBg, padding: const EdgeInsets.all(15)),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (route) => false),
            child: const Text('Back to home'),
          )),
        ]),
      ))),
    );
  }
}

class _TicketLine extends StatelessWidget {
  final String label, value;
  const _TicketLine({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
    Text(label, style: const TextStyle(color: muted)), const Spacer(),
    Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
  ]));
}

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;
    return Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(22, 24, 22, 18), child: Row(children: [
        const Expanded(child: Text('My Bookings', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
        Text('${bookings.length} ticket(s)', style: const TextStyle(color: muted)),
      ])),
      Expanded(child: bookings.isEmpty
        ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.confirmation_number_outlined, size: 64, color: muted),
            SizedBox(height: 12),
            Text('No bookings yet', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('Your confirmed tickets will appear here.', style: TextStyle(color: muted)),
          ]))
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final b = bookings[index];
              return Card(color: panelBg, child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFF49385F), child: Icon(Icons.movie, color: accent)),
                title: Text(b.movie, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${b.date} • ${b.time}\nSeats: ${b.seats.join(', ')}'),
                isThreeLine: true,
                trailing: Text('₹${b.total.toInt()}', style: const TextStyle(color: accent, fontWeight: FontWeight.bold)),
              ));
            },
          )),
    ]);
  }
}
