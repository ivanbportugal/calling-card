export default function Footer() {
  const year = new Date().getFullYear()

  return (
    <footer className="site-footer mt-20 px-4 pb-14 pt-10 text-[var(--sea-ink-soft)]">
      <div className="page-wrap flex flex-col items-center justify-between gap-4 text-center sm:flex-row sm:text-left">
        <p className="m-0 flex items-center gap-2 text-sm font-semibold text-[var(--sea-ink)]">
          <span className="h-2 w-2 rounded-full bg-[linear-gradient(90deg,#22c55e,#4ade80)]" />
          Calling Card
        </p>
        <p className="m-0 text-sm">&copy; {year} Calling Card. All rights reserved.</p>
      </div>
    </footer>
  )
}
