import { createFileRoute } from '@tanstack/react-router'
import appScreens from '../assets/app-screens.jpeg'

export const Route = createFileRoute('/')({ component: App })

const FEATURES: Array<[string, string]> = [
  [
    'Set your status in one tap',
    'Anyone can come, only one can come, or no one can come — pick it and your friends know instantly.',
  ],
  [
    'See who’s open right now',
    'Your friends list shows everyone’s current status at a glance, no texting around required.',
  ],
  [
    'Activity feed',
    'Get a quiet log of status changes as they happen — Sarah opened up, Mike closed the door.',
  ],
  [
    'Just your circle',
    'Calling Card only shares your status with friends you’ve added. No public profile, no strangers.',
  ],
]

const STEPS: Array<[string, string]> = [
  ['Add your friends', 'Bring in the people you actually want dropping by.'],
  [
    'Set your door status',
    'Friends can come, only one can come, or no one right now — whatever’s true.',
  ],
  [
    'They just know',
    'No group chat needed. Everyone sees your status the moment it changes.',
  ],
]

function App() {
  return (
    <main className="px-4 pb-8">
      <section className="page-wrap grid items-center gap-10 pb-4 pt-14 lg:grid-cols-[1.1fr_0.9fr] lg:gap-6">
        <div className="rise-in">
          <p className="island-kicker mb-3">For friends who just drop by</p>
          <h1 className="display-title mb-5 max-w-xl text-4xl leading-[1.05] font-bold tracking-tight text-[var(--sea-ink)] sm:text-6xl">
            Let your friends know when your door is open.
          </h1>
          <p className="mb-8 max-w-lg text-base text-[var(--sea-ink-soft)] sm:text-lg">
            Calling Card is a simple status for your closest friends: anyone
            can come over, only one can come over, or not right now. Set it
            once, everyone just knows.
          </p>
          <div className="flex flex-wrap gap-3">
            <a
              href="#download"
              className="rounded-full bg-[var(--lagoon)] px-6 py-3 text-sm font-semibold text-white no-underline shadow-[0_16px_32px_rgba(21,128,61,0.28)] transition hover:-translate-y-0.5"
            >
              Get the app
            </a>
            <a
              href="#how-it-works"
              className="rounded-full border border-[rgba(20,90,50,0.2)] bg-white/50 px-6 py-3 text-sm font-semibold text-[var(--sea-ink)] no-underline transition hover:-translate-y-0.5 hover:border-[rgba(20,90,50,0.35)]"
            >
              See how it works
            </a>
          </div>
        </div>

        <div className="rise-in relative mx-auto" style={{ animationDelay: '120ms' }}>
          <div className="pointer-events-none absolute -left-16 -top-16 h-56 w-56 rounded-full bg-[radial-gradient(circle,var(--hero-a),transparent_66%)]" />
          <div className="pointer-events-none absolute -bottom-16 -right-10 h-56 w-56 rounded-full bg-[radial-gradient(circle,var(--hero-b),transparent_66%)]" />
          <div className="phone-shell relative">
            <div className="phone-notch" />
            <div className="phone-screen">
              <div className="mb-4 flex items-center justify-between">
                <span className="display-title text-lg font-bold text-[var(--sea-ink)]">
                  Home
                </span>
                <span className="text-xs text-[var(--sea-ink-soft)]">9:41</span>
              </div>

              <p className="island-kicker mb-2">My Status</p>
              <div
                className="mb-3 flex items-center justify-between rounded-2xl px-4 py-3 text-white"
                style={{ background: 'linear-gradient(135deg, var(--status-anyone), var(--lagoon-deep))' }}
              >
                <div>
                  <p className="m-0 text-sm font-semibold">Friends can come</p>
                  <p className="m-0 text-xs opacity-80">My door is open!</p>
                </div>
              </div>

              <div className="mb-4 grid grid-cols-3 gap-2">
                <div className="status-tile" style={{ background: 'var(--status-anyone)' }}>
                  Anyone
                </div>
                <div className="status-tile" style={{ background: 'var(--status-one)' }}>
                  Only one
                </div>
                <div className="status-tile" style={{ background: 'var(--status-none)' }}>
                  No one
                </div>
              </div>

              <p className="island-kicker mb-1">Friends</p>
              <div className="divide-y divide-[var(--line)]">
                {[
                  ['Sarah', 'var(--status-anyone)', 'Friends can come'],
                  ['Mike', 'var(--status-one)', 'Only one can come'],
                  ['Jessica', 'var(--status-none)', 'No one can come'],
                ].map(([name, color, label]) => (
                  <div key={name} className="friend-row">
                    <span className="friend-avatar" />
                    <div className="min-w-0">
                      <p className="m-0 text-sm font-semibold text-[var(--sea-ink)]">
                        {name}
                      </p>
                      <p className="m-0 text-xs text-[var(--sea-ink-soft)]">
                        <span
                          className="status-dot"
                          style={{ background: color as string }}
                        />
                        {label}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </section>

      <section id="features" className="page-wrap mt-16 scroll-mt-24">
        <p className="island-kicker mb-2 text-center">Why Calling Card</p>
        <h2 className="display-title mb-8 text-center text-3xl font-bold text-[var(--sea-ink)] sm:text-4xl">
          One status. Everyone in the loop.
        </h2>
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {FEATURES.map(([title, desc], index) => (
            <article
              key={title}
              className="island-shell feature-card rise-in rounded-2xl p-5"
              style={{ animationDelay: `${index * 90 + 80}ms` }}
            >
              <h3 className="mb-2 text-base font-semibold text-[var(--sea-ink)]">
                {title}
              </h3>
              <p className="m-0 text-sm text-[var(--sea-ink-soft)]">{desc}</p>
            </article>
          ))}
        </div>
      </section>

      <section id="how-it-works" className="page-wrap mt-16 scroll-mt-24">
        <div className="island-shell rounded-[2rem] p-6 sm:p-10">
          <p className="island-kicker mb-2 text-center">How it works</p>
          <h2 className="display-title mb-8 text-center text-3xl font-bold text-[var(--sea-ink)] sm:text-4xl">
            Three steps. That’s it.
          </h2>
          <div className="grid gap-6 sm:grid-cols-3">
            {STEPS.map(([title, desc], index) => (
              <div key={title} className="text-center">
                <div
                  className="mx-auto mb-4 flex h-10 w-10 items-center justify-center rounded-full text-sm font-bold text-white"
                  style={{ background: 'linear-gradient(135deg, var(--lagoon), var(--lagoon-deep))' }}
                >
                  {index + 1}
                </div>
                <h3 className="mb-2 text-base font-semibold text-[var(--sea-ink)]">
                  {title}
                </h3>
                <p className="m-0 text-sm text-[var(--sea-ink-soft)]">{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section id="screenshots" className="page-wrap mt-16 scroll-mt-24">
        <p className="island-kicker mb-2 text-center">See it in action</p>
        <h2 className="display-title mb-8 text-center text-3xl font-bold text-[var(--sea-ink)] sm:text-4xl">
          Light mode, dark mode, always clear.
        </h2>
        <div className="island-shell overflow-hidden rounded-[2rem] p-2 sm:p-3">
          <img
            src={appScreens}
            alt="Calling Card app screens showing the home status view in light and dark mode, the notifications feed, and a friend's profile"
            className="w-full rounded-[1.5rem]"
          />
        </div>
      </section>

      <section id="download" className="page-wrap mt-16 scroll-mt-24">
        <div
          className="rise-in rounded-[2rem] px-6 py-12 text-center text-white sm:px-10"
          style={{ background: 'linear-gradient(135deg, var(--lagoon), var(--lagoon-deep))' }}
        >
          <h2 className="display-title mb-4 text-3xl font-bold sm:text-4xl">
            Ready to open your door?
          </h2>
          <p className="mx-auto mb-8 max-w-xl text-sm opacity-90 sm:text-base">
            Calling Card is free to use with your friends. Download it and set
            your first status in under a minute.
          </p>
          <div className="flex flex-wrap justify-center gap-3">
            <span
              aria-disabled="true"
              className="cursor-not-allowed rounded-full bg-white/80 px-6 py-3 text-sm font-semibold text-[var(--lagoon-deep)] opacity-80"
            >
              App Store — coming soon
            </span>
            <span
              aria-disabled="true"
              className="cursor-not-allowed rounded-full border border-white/40 px-6 py-3 text-sm font-semibold text-white opacity-80"
            >
              Google Play — coming soon
            </span>
          </div>
        </div>
      </section>
    </main>
  )
}
