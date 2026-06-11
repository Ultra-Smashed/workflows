import { ArrowRight, BadgeEuro, Check, Gem, Globe2, ShieldCheck, Sparkles, Zap } from 'lucide-react'

const currencyMode =
  process.env.BILLING_CURRENCY?.toLowerCase() === 'eur'
    ? 'BILLING_CURRENCY=eur'
    : 'Euro overlay preview'

const PLANS = [
  {
    name: 'Community',
    price: '€0',
    period: 'forever',
    description: 'Prototype agents, tables, and knowledge workflows without a card.',
    accent: 'from-cyan-200 to-lime-200',
    features: ['1,000 starter credits', '5 GB file storage', '1 personal workspace'],
    featured: false,
  },
  {
    name: 'Pro',
    price: '€25',
    period: 'per month',
    description: 'Launch production automations with predictable monthly credits.',
    accent: 'from-lime-200 to-emerald-200',
    features: ['6,000 credits/month', '50 GB file storage', '3 personal workspaces'],
    featured: true,
  },
  {
    name: 'Max',
    price: '€100',
    period: 'per month',
    description: 'Scale multi-step agents with deeper usage pools and team-ready limits.',
    accent: 'from-pink-200 to-amber-100',
    features: ['25,000 credits/month', '500 GB file storage', '10 personal workspaces'],
    featured: false,
  },
] as const

const PROOF_POINTS = [
  {
    label: 'Built for EU buyers',
    value: '€',
    description: 'Every primary price and structured plan callout uses euro display.',
  },
  {
    label: 'Open-source core',
    value: 'OSS',
    description: 'Keep the builder self-hostable while presenting a polished commercial overlay.',
  },
  {
    label: 'Agent workflow ready',
    value: '1k+',
    description: 'Position integrations, models, and workflow execution in one sales narrative.',
  },
] as const

const STEPS = [
  'Connect the systems your team already uses.',
  'Build the first agent visually in the workflow builder.',
  'Run, inspect, and iterate before scaling to paid usage.',
] as const

export default function MarketingPage() {
  return (
    <main className='min-h-screen overflow-hidden px-5 py-6 sm:px-8 lg:px-12'>
      <section className='relative mx-auto flex max-w-7xl flex-col gap-10 rounded-[2rem] border border-white/10 bg-white/[0.03] p-4 shadow-2xl shadow-black/40 backdrop-blur md:p-6 lg:p-8'>
        <div className='absolute inset-x-8 top-0 h-px bg-gradient-to-r from-transparent via-white/50 to-transparent' />

        <nav className='flex items-center justify-between gap-4'>
          <a href='/' className='flex items-center gap-3'>
            <span className='flex size-10 items-center justify-center rounded-2xl bg-white text-black shadow-lg shadow-lime-300/20'>
              <Sparkles className='size-5' aria-hidden='true' />
            </span>
            <span className='font-semibold text-lg tracking-tight'>Sim Euro Overlay</span>
          </a>
          <div className='hidden items-center gap-2 rounded-full border border-white/10 bg-white/5 px-4 py-2 text-sm text-white/70 sm:flex'>
            <BadgeEuro className='size-4 text-[var(--marketing-euro)]' aria-hidden='true' />
            {currencyMode}
          </div>
        </nav>

        <div className='grid gap-8 lg:grid-cols-[1.05fr_0.95fr] lg:items-end'>
          <div className='max-w-3xl'>
            <div className='mb-5 inline-flex items-center gap-2 rounded-full border border-lime-200/20 bg-lime-200/10 px-3 py-1 text-lime-100 text-sm'>
              <Globe2 className='size-4' aria-hidden='true' />
              European pricing narrative for Sim
            </div>
            <h1 className='max-w-4xl text-balance font-semibold text-5xl tracking-[-0.06em] sm:text-6xl lg:text-7xl'>
              Ship AI workflows with pricing that already speaks in euros.
            </h1>
            <p className='mt-6 max-w-2xl text-lg text-white/68 leading-8'>
              A focused marketing overlay for EU-facing launches: clear plan cards, explicit euro
              display, and a buyer story that connects the visual builder to measurable automation.
            </p>
            <div className='mt-8 flex flex-col gap-3 sm:flex-row'>
              <a
                href='http://localhost:3000/signup'
                className='group inline-flex items-center justify-center gap-2 rounded-full bg-[var(--marketing-euro)] px-6 py-3 font-semibold text-black transition hover:bg-white'
              >
                Start building
                <ArrowRight
                  className='size-4 transition group-hover:translate-x-0.5'
                  aria-hidden='true'
                />
              </a>
              <a
                href='http://localhost:3000/#pricing'
                className='inline-flex items-center justify-center rounded-full border border-white/14 bg-white/5 px-6 py-3 font-medium text-white/82 transition hover:bg-white/10'
              >
                Compare plans
              </a>
            </div>
          </div>

          <aside className='relative rounded-[1.7rem] border border-white/12 bg-black/30 p-5 shadow-2xl shadow-lime-200/10'>
            <div className='-top-10 absolute right-8 h-24 w-24 rounded-full bg-[var(--marketing-euro)] opacity-30 blur-3xl' />
            <div className='flex items-center justify-between gap-4'>
              <div>
                <p className='text-sm text-white/50'>Hello-world workflow</p>
                <h2 className='mt-1 font-semibold text-2xl tracking-tight'>Builder smoke path</h2>
              </div>
              <Zap className='size-8 text-[var(--marketing-euro)]' aria-hidden='true' />
            </div>
            <ol className='mt-6 grid gap-3'>
              {STEPS.map((step, index) => (
                <li
                  key={step}
                  className='flex items-start gap-3 rounded-2xl border border-white/10 bg-white/[0.04] p-4'
                >
                  <span className='flex size-7 shrink-0 items-center justify-center rounded-full bg-white text-black text-sm'>
                    {index + 1}
                  </span>
                  <span className='text-white/72'>{step}</span>
                </li>
              ))}
            </ol>
          </aside>
        </div>

        <div className='grid gap-4 lg:grid-cols-3'>
          {PLANS.map((plan) => (
            <article
              key={plan.name}
              className='relative flex min-h-[24rem] flex-col justify-between overflow-hidden rounded-[1.5rem] border border-white/12 bg-white/[0.045] p-5'
            >
              <div
                className={`absolute inset-x-0 top-0 h-1 bg-gradient-to-r ${plan.accent}`}
                aria-hidden='true'
              />
              {plan.featured && (
                <div className='absolute top-5 right-5 rounded-full bg-white px-3 py-1 font-medium text-black text-xs'>
                  Most popular
                </div>
              )}
              <div>
                <h2 className='font-semibold text-2xl tracking-tight'>{plan.name}</h2>
                <p className='mt-3 min-h-14 text-sm text-white/62 leading-6'>{plan.description}</p>
                <div className='mt-8 flex items-end gap-2'>
                  <span className='font-semibold text-5xl tracking-[-0.06em]'>{plan.price}</span>
                  <span className='pb-2 text-sm text-white/50'>{plan.period}</span>
                </div>
              </div>
              <ul className='mt-8 grid gap-3'>
                {plan.features.map((feature) => (
                  <li key={feature} className='flex items-center gap-3 text-sm text-white/72'>
                    <span className='flex size-5 items-center justify-center rounded-full bg-white/10'>
                      <Check className='size-3.5 text-[var(--marketing-euro)]' aria-hidden='true' />
                    </span>
                    {feature}
                  </li>
                ))}
              </ul>
            </article>
          ))}
        </div>

        <section className='grid gap-4 lg:grid-cols-3'>
          {PROOF_POINTS.map((point) => (
            <div
              key={point.label}
              className='rounded-[1.4rem] border border-white/10 bg-white/[0.035] p-5'
            >
              <div className='flex items-center justify-between gap-4'>
                <p className='text-sm text-white/54'>{point.label}</p>
                {point.value === '€' ? (
                  <BadgeEuro className='size-6 text-[var(--marketing-euro)]' aria-hidden='true' />
                ) : point.value === 'OSS' ? (
                  <ShieldCheck className='size-6 text-[var(--marketing-cyan)]' aria-hidden='true' />
                ) : (
                  <Gem className='size-6 text-[var(--marketing-pink)]' aria-hidden='true' />
                )}
              </div>
              <p className='mt-4 font-semibold text-4xl tracking-[-0.05em]'>{point.value}</p>
              <p className='mt-3 text-sm text-white/58 leading-6'>{point.description}</p>
            </div>
          ))}
        </section>
      </section>
    </main>
  )
}
